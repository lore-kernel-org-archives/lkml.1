Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZHMJo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZHMJo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZHMJo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:44:28 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:59077 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZHMJo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NEE1Uktsmivlqb0shiND7tahutTout2Ucba+TQUvI4pcvFDPHa6o3ocUUejowwYGm5
         /4o6v4KX33o2lj+CDQ0IjIVauRuYw8pPWzA3GRCtFDDZQDKPn3LTVsIKg05rI/DboaF1
         4nvPXTg7WKXG+P3NTR23Rbk9xD3sT9WToVXKE=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <20090813090743.GA14352@elte.hu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
	 <u1L1PAbl8zG.A.UBD.ej1fKB@chimera>
	 <11fae7c70908130152j21f9f183m4f1c49d91fc7a7f9@mail.gmail.com>
	 <20090813090743.GA14352@elte.hu>
Date: Thu, 13 Aug 2009 12:44:27 +0300
X-Google-Sender-Auth: 2d243e502ce1f870
Message-ID: <11fae7c70908130244k3f20954ewa23c5a57fbd60410@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Viro <viro@ftp.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Martin-Éric Racine <q-funk@iki.fi> wrote:
>
>> Yes, this bug is still valid.
>>
>> Ubuntu kernel team member Leann Ogasawara and I are slowly
>> bisecting our way through the changes that took place since 2.6.30
>> to find the commit that introduced this regression. Please stay
>> tuned.
>
> hm, the only outright Geode related commit was:
>
>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
>
> the jpg at:
>
>  http://launchpadlibrarian.net/28892781/00002.jpg
>
> is very out of focus - but what i could decypher suggests a
> pagefault crash in the VFS code, in generic_delete_inode().

There's a few more JPEG images below that have a slightly sharper image.

> Which could be a VFS bug, or a filesystem bug, or some unrelated
> memory corruption hitting the inode data structure.

It could indeed be many things.

I've been trying to boot this into a larger framebuffer to be able to
fit more data into my snapshots, but it appears that vga=795 doesn't
work anymore. Have we reverted to Hex values again or is this just an
issue of some kernel module missing from initrd?

Martin-Éric
