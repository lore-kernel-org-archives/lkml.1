Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXFWUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXFWUWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 16:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXFWUW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 16:22:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18959 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXFWUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 16:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PKMT4nF+ZthLUJlBqQukYMwMLa80rBNcOgFPTyEtmvdjQ7X8UfNnSD4rfubaKLnXwH04P/atGLoXkCsdvm2SR5hkpX4YGhmOmCYqmRKFEQMOPuzjYx0NU+f2vq63GB7CoIogJKlJH/FRXt8aD481siuc3lxaPixddJgmfrE8KwE=
Message-ID: <467D8141.7040604@gmail.com>
Date: Sun, 24 Jun 2007 00:23:29 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Wolfgang Draxinger <wdraxinger@darkstargames.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux on XScale 270
References: <200706231618.44659.wdraxinger@darkstargames.de>
In-Reply-To: <200706231618.44659.wdraxinger@darkstargames.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Draxinger wrote:
> Typing "Linux XScale 270 or 27x" brings you a lot of pages but not an 

Probably "XScale 270" is not the best word combination for this,
the exact processor name is PXA270 (formerly Intel, now Marvell).
> in depth doc/HOWTO how to compile your own kernel and make a boot 
> image for that arch. The vendor from which I get the XScale sponsored 
> has ready to use Linux images and source on his webpage, but they're 
> kinda old and dusty.
> http://www.toradex.ch/colibri_downloads/Linux/
>
> So what are the steps I've to take, to get a Linux Kernel on a XScale?

Assuming the mainline kernel already includes support for your machine,

1. get the latest stable Linux kernel
2. compile the kernel:
    make ARCH=arm CROSS_COMPILE=<your_crosscompiler_prefix> 
<your_machine_name>_defconfig
    make <kernel_image_name>

    For example, to compile the kernel for Mainstone platform
    with blob flashed, do the following:
   
    make ARCH=arm CROSS_COMPILE=arm-linux- mainstone_defconfig
    make zImage

3. boot the image as appropriate for your bootloader
>  
> It's obvious that I need a cross compiler for ARM, bootloader images 
> and so on, but it's the gory details I'm curios about.
>
> Links to HOWTOs, documentation highly appreciated. And probably 
> there's also a better suited maillist than LKML for this, to a 
> pointer to that (if existing) would be nice, too.
>

linux-arm-kernel@lists.arm.linux.org.uk   - for kernel-specific issues
linux-arm@lists.arm.linux.org.uk          - for general questions

these are the most appropriate lists for your questions
(your subscription is required).


Regards,
Dmitry
