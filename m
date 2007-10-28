Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXJ1Uko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXJ1Uko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXJ1Ukh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:40:37 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34304 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXJ1Ukg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:40:36 -0400
Date: Sun, 28 Oct 2007 21:39:50 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
cc: Adrian Bunk <bunk@kernel.org>, Nick Sillik <n.sillik@temple.edu>,
       David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [RFC: 2.6 patch] remove the USB_STORAGE_ONETOUCH driver
In-Reply-To: <64bb37e0710281048x589ab063o8a32294e30488979@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710282134020.18815@twin.jikos.cz>
References: <20071028155212.GC7227@stusta.de>
 <64bb37e0710281048x589ab063o8a32294e30488979@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Torsten Kaiser wrote:

> But it looks like that uses another driver:
> hiddev0hidraw1: USB HID v1.10 Device [Western Digital External HDD] on
> usb-0000:00:02.1-5.2
> Otherwise I would be willing to try to test this, if someone would tell 
> me how to check that the second commit did fix the suspend problem.

If you need to unbind usbhid driver from the device and bind another one, 
you can use the 'unbind' and 'bind' files in sysfs.

As soon as the driver you are willing to test is bound to the device, you 
can go ahead with testing any functionality you wish (probably 
suspend/resume cycle is needed here?).

If the device is claimed by usbhid driver (because its descriptor probably 
states that it's HID-compliant device) and should be claimed by another 
driver, it's necessary to add it to usbhid blacklist -- just let me know.

-- 
Jiri Kosina
