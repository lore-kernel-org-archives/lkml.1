Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZASQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZASQ7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZASQ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:59:05 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:62111 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZASQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:59:03 -0500
X-Greylist: delayed 163082 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 11:59:03 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aRYLLEqR/GNid5dldd/LvnflgEEIjqwka877uH0v50SA6Oy5gCktgmUfAmVFMiz21n
         Z19HwEwr2WoGGUAmXyBjrCi+rwGSjowJVvfhJfU76eMb5BCCcUIoJcUN76kwfrWU6bpt
         sRi4v3CtGL3bPwWe4jb1xMShDZwDT2N3BvjM0=
Date: Mon, 19 Jan 2009 18:59:26 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemtrace: kbuild failed to make the new header symlink...
Message-ID: <20090119165926.GA5287@localhost>
References: <20090119164029.GB19302@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119164029.GB19302@ghostprotocols.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 02:40:29PM -0200, Arnaldo Carvalho de Melo wrote:
> Sam,
> 
> 	I just did a git pull on linux-2.6-tip, then, on a build
> directory (make O=../build/blkftrace/) with a previous build a tree
> cloned from Linus I got stuck with the messages below.
> 
> 	I could only get this to work after a make mrproper, thought I
> could mention this so that perhaps this can get detected and time be
> saved somehow.
> 
>   CC      arch/x86/mm/fault.o
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:38:27: error: asm/kmemcheck.h: No such file or directory
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c: In function ???do_page_fault???:
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:614: error: implicit declaration of function ???kmemcheck_active???
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:615: error: implicit declaration of function ???kmemcheck_hide???
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:644: error: implicit declaration of function ???kmemcheck_fault???

Hi,

This looks like a kmemcheck, not kmemtrace, fault. Heh, but we already
have 3 things with similar names: kmemcheck, kmemtrace and kmemleak. :)


	Cheers,
	Eduard

