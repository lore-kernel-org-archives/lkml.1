Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZGTTXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZGTTXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZGTTXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:23:30 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:62402 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZGTTX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=LeBPCxS3697w51HivfG1IJSiKfGRN63vgo9z/w8JE6fAYYapE80JAJSFR0lU0iPJRk
         L5hD5f5gGahWFRFVp8iR8cHUQj0v47p0Erbi+dWwShji2CKwEEh40z+NKsiYqey8ZCJ6
         1EbL47T0iaWRaAUutoSUpQtpK/R9cxnU6+Li8=
Date: Mon, 20 Jul 2009 21:23:18 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Greg KH <gregkh@suse.de>, Wolfgang Walter <wolfgang.walter@stwm.de>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720212318.2aa5be21@varda>
In-Reply-To: <20090720180333.GA2905@brouette>
References: <20090720040813.GC11940@kroah.com>
	<200907201613.22483.wolfgang.walter@stwm.de>
	<20090720150916.GB10015@suse.de>
	<20090720180333.GA2905@brouette>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 20 Jul 2009 20:03:33 +0200
Damien Wyart <damien.wyart@free.fr> escribió:

> > > Built 2.6.30.2 but it hangs when booting immediately after the message:
> 
> > > Booting the kernel.
> 
> > > I built it with gcc version 4.3.3 on debian/sid and used exactly the
> > > same .config as I used with 2.6.32.1 (ok, + "DEFAULT_MMAP_MIN_ADDR
> > > 4096" which didn't exist before).
> 
> * Greg KH <gregkh@suse.de> [2009-07-20 08:09]:
> > Can you do 'git bisect' to see which patch caused the problem? It
> > might be the one, "Don't use '-fwrapv' compiler option: it's buggy in
> > gcc-4.1.x", but it would be good to figure it out for sure.
> 
> I am seeing a similar problem (no hang but an immediate reboot) on the
> same distro. I tried to bisect but got no good kernel in the end.
> 
> To clarify things I recompiled again 2.6.30.1 with the orginial .config
> and it also failed to boot (I was happy to have renamed it so the
> working kernel was still available). I suspected a recent gcc 4.3
> upgrade so downgraded gcc, but no luck, still getting the same problem.
> So for now I am quite stuck, but there is clearly a bad problem
> somewhere...
> 
I did not have any probelm with the gcc shipped in ubuntu gcc (Ubuntu
4.3.3-5ubuntu4) 4.3.3 (64 bit jaunty 9.04)

All three 2.6.30 2.6.30.1 and .2 boot just fine (i carry a revert but i
doubt it changes things)

