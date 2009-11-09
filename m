Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZKIKgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZKIKgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZKIKgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:36:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57342 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZKIKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:36:03 -0500
Date: Mon, 9 Nov 2009 11:36:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: dream: fastboot getting protocol errors
Message-ID: <20091109103602.GC2207@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm still fighting with porting MMC support to current mainline.

Meanwhile: I'm getting this *way* too often -- with the htcUSB  to
2xUSB reduction. Any ideas?

root@amd:/data/l/android# ./fastboot -c "console=tty0
root=/dev/mmcblk0p1 rootdelay=5 fbcon=rotate:1" boot
/data/l/linux-msm/arch/arm/boot/zImage
creating boot image...
creating boot image - 1667072 bytes
downloading 'boot.img'... FAILED (command write failed (Protocol
error))
root@amd:/data/l/android# 

...and then it just goes away after powercycling the phone...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
