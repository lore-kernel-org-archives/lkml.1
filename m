Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYAHOUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYAHOUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYAHOUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:20:36 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:49240 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYAHOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:20:35 -0500
Date: Tue, 8 Jan 2008 09:39:52 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: cksim <cksim@singnet.com.sg>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: Odd behaviour observed on fb0 (TFT LCD screen 800x480)
In-Reply-To: <1199675857.478199d155026@discus.singnet.com.sg>
Message-ID: <Pine.LNX.4.64.0801080939290.13329@anakin>
References: <1199675857.478199d155026@discus.singnet.com.sg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, cksim wrote:
> Lately, I have observed an odd behviour in kernel 2.6.23.1 on a 800x480 TFT LCD unit.
> 
> The odd behviour as follows:
> 1) I am using Atmel AT91SAM9261 part. Circuit similar to that of AT91SAM9261EK evaluation board.
> 
> 2) I am booting the kernel and mounting root filesystem through NFS. Bootloader used is UBoot 1.1.5.
> 
> 3) During kernel startup, the LCD screen shows the "Penguin" logo with the other console output messages.
> 
> 4) Everything looks fine up to this point. For example, the 0,0 position of image on LCD is proper and correct.
> 
> 5) The root filesystem is then mounted through NFS and followed by a message "Freeing init memory: 106K". All this are fine.
> 
> 6) During the execution of init scripts and the login prompt, the image on the screen starts shifting (either left, right, up or down). For example, the 0,0 position of the LCD image is shifted. However, the image content is still correct.
> 
> 7) After login, this image shift behaviour still exists during normal usage.
> 
> In contrast, when using kernel 2.6.21, the image shift behaviour was not observed before the login prompt. Image shift after the login does happen occasionally but not as frequent as that seen in 2.6.23.1.
> 
> Has anyone encountered a similar image shift issue ?
> 
> Is this issue related to kernel ? It appears to me that some timing causes the image shifting.

Probably it's related to the frame buffer driver for your board.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
