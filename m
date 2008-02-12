Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYBLPAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYBLPAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYBLPAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:00:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbYBLPAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:00:17 -0500
Date: Tue, 12 Feb 2008 12:59:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Toth <stoth@hauppauge.com>
Subject: Re: build #345 issue for v2.6.25-rc1 in tuner-core.c
Message-ID: <20080212125948.7e1dbf0a@gaivota>
In-Reply-To: <47B105B8.7010900@linuxtv.org>
References: <200802111154.31760.toralf.foerster@gmx.de>
	<20080212004251.GT6887@bakeyournoodle.com>
	<47B105B8.7010900@linuxtv.org>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 21:34:32 -0500
Michael Krufky <mkrufky@linuxtv.org> wrote:

> Tony Breeds wrote:
> > On Mon, Feb 11, 2008 at 11:54:31AM +0100, Toralf Förster wrote:
> >   
> >> Hello,
> >>
> >> the build with the attached .config failed, make ending with:
> >> ...
> >>   MODPOST vmlinux.o
> >> WARNING: modpost: Found 12 section mismatch(es).
> >> To see full details build your kernel with:
> >> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >>   GEN     .version
> >>   CHK     include/linux/compile.h
> >>   UPD     include/linux/compile.h
> >>   CC      init/version.o
> >>   LD      init/built-in.o
> >>   LD      .tmp_vmlinux1
> >> drivers/built-in.o: In function `set_type':
> >> tuner-core.c:(.text+0x8879d): undefined reference to `xc5000_attach'
> >> make: *** [.tmp_vmlinux1] Error 1
> >>     
> >
> > <snip>
> > Fix Build error for xc5000 tuner when built as module.
> >
> > Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> >   
> Patch is correct.  Not sure which tag is appropriate.....
> 
> Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
> 
> This should go straight to Linus.....  Andrew or Mauro, can one of you
> take care of it?

I should forward today some patches to Linus. I'll add this one to the list.


Cheers,
Mauro
