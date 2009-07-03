Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZGCCRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZGCCRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZGCCR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:17:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:41762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbZGCCRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:17:25 -0400
Subject: Reminder for feature PCMCIA control ioctl removal date Nov 2005
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Dominik Brodowski <linux@brodo.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:29:54 +0530
Message-Id: <1246586394.2530.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dominik,

What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
When:   November 2005
Files:  drivers/pcmcia/: pcmcia_ioctl.c
Why:    With the 16-bit PCMCIA subsystem now behaving (almost) like a
        normal hotpluggable bus, and with it using the default kernel
        infrastructure (hotplug, driver core, sysfs) keeping the PCMCIA
        control ioctl needed by cardmgr and cardctl from pcmcia-cs is
        unnecessary, and makes further cleanups and integration of the
        PCMCIA subsystem into the Linux kernel device driver model more
        difficult. The features provided by cardmgr and cardctl are either
        handled by the kernel itself now or are available in the new
        pcmciautils package available at
        http://kernel.org/pub/linux/utils/kernel/pcmcia/
Who:    Dominik Brodowski <linux@brodo.de>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

