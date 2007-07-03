Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbXGEBGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbXGEBGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 21:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbXGEBGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 21:06:15 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:54918 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbXGEBGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 21:06:15 -0400
X-Greylist: delayed 92534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 21:06:15 EDT
Message-ID: <468ADA8D.10108@blueyonder.co.uk>
Date: Wed, 04 Jul 2007 00:23:57 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ov511 module does not build
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the same setup in .config for linux-2.6.22-rc2-git7, it builds, 
after that and right up to linux-2.6.22-rc7-git1 it doesn't.
/usr/src/linux-2.6.22-rc2-git7/drivers/media/video/ov511.ko
# CONFIG_VIDEO_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
In any of the 2.6.22-rc kernels, there is no option to select OV511.
tindog:/usr/src/linux-2.6.22-rc2-git7 # grep -i ov511 .config
tindog:/usr/src/linux-2.6.22-rc2-git7 #

tindog:/usr/src/linux-2.6.22-rc7-git1 # diff 
../linux-2.6.22-rc2-git7/drivers/media/video/Kconfig 
drivers/media/video/Kconfig
14c14
< if VIDEO_CAPTURE_DRIVERS
---
 > if VIDEO_CAPTURE_DRIVERS && VIDEO_DEV
694c694
< if V4L_USB_DRIVERS
---
 > if V4L_USB_DRIVERS && USB
tindog:/usr/src/linux-2.6.22-rc7-git1 # grep V4L .config
# CONFIG_VIDEO_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_V4L_USB_DRIVERS=y

tindog:/usr/src/linux-2.6.22-rc2-git7 # grep V4L .config
# CONFIG_VIDEO_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
# CONFIG_V4L_USB_DRIVERS is not set

Still does not build for 2.6.22-rc7-git2 with .config set with

# CONFIG_V4L_USB_DRIVERS is not set

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


