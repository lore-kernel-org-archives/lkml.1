Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZKALx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZKALx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 06:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZKALx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 06:53:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:40967 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZKALx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 06:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CJOs24YpBwjfwwlxtzGiftvVdW4zl6Bp+U/yC0BBQ2Oiv4pUZgDwF3F+qDm/tqa1bX
         reVSqNsrVNff9xv/fGzwQBU8/Vsx+iC0ynmnogwP/LwlT/RcImcnuZ3aBUuWSC/5HZhG
         lggjPqhfIAnrLRaCgoi/bt4ZAnDtGaYWQ0bRU=
MIME-Version: 1.0
In-Reply-To: <4AE7BA65.6070502@blueyonder.co.uk>
References: <4AE7BA65.6070502@blueyonder.co.uk>
Date: Sun, 1 Nov 2009 13:53:29 +0200
Message-ID: <94a0d4530911010353n38d0627ev69bf891005365e9@mail.gmail.com>
Subject: Re: 2.6.32-rc5 omap build error
From: Felipe Contreras <felipe.contreras@gmail.com>
To: g3vbv@blueyonder.co.uk
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 5:28 AM, Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
> [root@localhost linux-omap-2.6]# ARCH=arm make
> CROSS_COMPILE=/opt/arm-2009q1/bin/arm-none-linux-gnueabi- uImage modules
>  CHK     include/linux/version.h
> make[1]: `include/asm-arm/mach-types.h' is up to date.
>  CHK     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-arm
>  CALL    scripts/checksyscalls.sh
>  CHK     include/linux/compile.h
>  CHK     include/linux/version.h
> make[2]: `scripts/unifdef' is up to date.
>  Kernel: arch/arm/boot/Image is ready
>  Kernel: arch/arm/boot/zImage is ready
>  UIMAGE  arch/arm/boot/uImage
> Image Name:   Linux-2.6.32-rc5-06331-g0bbf533-
> Created:      Wed Oct 28 01:57:13 2009
> Image Type:   ARM Linux Kernel Image (uncompressed)
> Data Size:    2236872 Bytes = 2184.45 kB = 2.13 MB
> Load Address: 0x80008000
> Entry Point:  0x80008000
>  Image arch/arm/boot/uImage is ready
>  Building modules, stage 2.
>  MODPOST 355 modules
> ERROR: "omap_ctrl_writel" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
> ERROR: "omap_ctrl_readl" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Why don't you send this to the linux-omap mailing list?

-- 
Felipe Contreras
