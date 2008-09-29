Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYI2JQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYI2JQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYI2JQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:16:04 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:44874 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751594AbYI2JQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:16:01 -0400
Date: Mon, 29 Sep 2008 10:15:55 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: vincen <mcuos.com@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: PATCH linux-2.6.27-rc7-git5]ARM:Add the Nuvoton w90P910
	Platform support to LINUX-ARM tree
Message-ID: <20080929091555.GB14564@fluff.org.uk>
References: <e68bb3470809280515v2079e787yf190af69ea1be3ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68bb3470809280515v2079e787yf190af69ea1be3ab@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 08:15:10PM +0800, vincen wrote:
> From: vincen.zswan mcuos.com@gmail.com
> 
> Dear sir,
> I have add the Nuvoton ARM series IC W90P910 Platform support to LINUX
> ARM tree and make a patch named patch-2.6.27-rc7-git5-w90p910.patch.
> 
> As the file size 177kb,so you can get the patch file from link:
> 
> http://www.mcuos.com/attachment.php?aid=583

If posting large patches, it would generally be much easier to split
them into smaller chunks of logical changes. For an example, the defconfig
addition could be seperated from the main submission, etc.

> If the patch file is not accepted by Linux, please give some advice ,
> I need to modify it better.thanks!
> 
> Only add the mach-w90x900 directory to /linux/arch/arm and modify
> Makefile and Kconfig.
> Now,The Platform code support only uart driver and add the
> w90p910_serial.c to /driver/serial and  modify Makefile and Kconfig.
> 
> The Platform default config in arch/arm/configs/w90p910_defconfig
> 
> Changes:
> patching file arch/arm/Kconfig
> patching file arch/arm/Makefile
> patching file arch/arm/configs/w90p910_defconfig
> 
> patching file arch/arm/mach-w90x900
> 
> patching file arch/arm/mm/Kconfig
> patching file drivers/serial/Kconfig
> patching file drivers/serial/Makefile
> patching file drivers/serial/w90x900_serial.c
> patching file include/linux/serial_core.h
> 
> -- 
> Vincen
> Signed-off-by: vincen.zswan <mcuos.com@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
