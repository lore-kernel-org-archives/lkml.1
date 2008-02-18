Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYBRQNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYBRQNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYBRQNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:13:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbYBRQNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:13:14 -0500
Date: Mon, 18 Feb 2008 13:13:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: build #355 issue for v2.6.25-rc2-15-g1309d4e in function
 v4l2_i2c_attach
Message-ID: <20080218131300.529b9862@gaivota>
In-Reply-To: <200802171121.13119.toralf.foerster@gmx.de>
References: <200802171121.13119.toralf.foerster@gmx.de>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 11:21:09 +0100
Toralf Förster <toralf.foerster@gmx.de> wrote:

> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `v4l2_i2c_attach':
> (.text+0x26c67): undefined reference to `i2c_attach_client'
> make: *** [.tmp_vmlinux1] Error 1

This bug were already fixed. I'm waiting for Linus to pull. The patches fixing
it are available at:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git

Cheers,
Mauro
