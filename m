Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZKIKm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZKIKm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZKIKm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:42:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47296 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZKIKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:42:55 -0500
Date: Mon, 9 Nov 2009 11:42:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: dream: fastboot getting protocol errors
Message-ID: <20091109104254.GA8757@elf.ucw.cz>
References: <20091109103602.GC2207@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109103602.GC2207@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-09 11:36:02, Pavel Machek wrote:
> Hi!
> 
> I'm still fighting with porting MMC support to current mainline.
> 
> Meanwhile: I'm getting this *way* too often -- with the htcUSB  to
> 2xUSB reduction. Any ideas?
> 
> root@amd:/data/l/android# ./fastboot -c "console=tty0
> root=/dev/mmcblk0p1 rootdelay=5 fbcon=rotate:1" boot
> /data/l/linux-msm/arch/arm/boot/zImage
> creating boot image...
> creating boot image - 1667072 bytes
> downloading 'boot.img'... FAILED (command write failed (Protocol
> error))
> root@amd:/data/l/android# 
> 
> ...and then it just goes away after powercycling the phone...

And this is another failure mode: display says "FASTBOOT", and serial
console says

UART0:Cmd>szCPLDstrlen=0x5

+usbloader_init
-usbloader_init


(but no message about usb highspeed mode), and fastboot hangs with 

root@amd:/data/l/android# ./fastboot -c "console=tty0
root=/dev/mmcblk0p1 rootdelay=5 fbcon=rotate:1" boot
/data/l/linux-dream-mainline/arch/arm/boot/zImage
creating boot image...
creating boot image - 1421312 bytes
< waiting for device >

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
