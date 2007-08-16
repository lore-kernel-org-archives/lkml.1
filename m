Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXHPNAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXHPNAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbXHPNA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:00:26 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35178 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbXHPNAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:00:25 -0400
Date: Thu, 16 Aug 2007 15:00:22 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB Keyboard
In-Reply-To: <Pine.LNX.4.61.0708160724001.17168@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0708161456450.2460@twin.jikos.cz>
References: <Pine.LNX.4.61.0708151320380.8581@chaos.analogic.com>
 <Pine.LNX.4.64.0708161100340.2460@twin.jikos.cz>
 <Pine.LNX.4.61.0708160724001.17168@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, linux-os (Dick Johnson) wrote:

> Okay. I found what was different. It does actually build, but it is now 
> put into a completely different directory, 
> /lib/modules/2.6.22.1/kernel/drivers/hid/usbhid, and requires 
> /lib/modules/2.6.22.1/kernel/drivers/input/ff-memless.ko to be installed 
> before it can be. 

Only if you enabled force feedback for HID devices in your menuconfig. And 
if you did so, it perfectly makes sense that the force-feedback input 
module must be loaded.

> None of this is documented and it makes upgrading extremely difficult, 
> expecially when a keyboard won't work anymore.

1) what strange distro/environment do you use that the usbhid driver is 
   not loaded automatically when you plug the keyboard in?
2) even if your module autoloading is that much broken, you can always ssh 
   to the box or attach PS/2 keyboard and modprobe usbhid ... that works 
   no matter which directory keeps the driver

There is nothing to be documented there, we don't document which directory 
holds which driver.

> BYW, it did fix the problem with the old driver.

Good to hear, thanks.

-- 
Jiri Kosina
