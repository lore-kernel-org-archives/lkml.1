Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZG0BMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZG0BMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 21:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZG0BMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 21:12:50 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:64307 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZG0BMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 21:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=TvcgAOtD6IbSRPoA8uCYRFX9iDxoyK64l1Sv223zUkpqk5q3PqdZjESCqzS+G4srlv
         VTLomF+Ukny3JeXP56YRrzGfuqWk3JoUoiejYSfvYlwecV2srbImxRC9Wu2jJhEej68x
         zmYCouCSyorxODl0pORO2QJXC1m9w4TjUvDLc=
MIME-Version: 1.0
Date: Sun, 26 Jul 2009 21:12:49 -0400
Message-ID: <dd18b0c30907261812p673a3ab3p8dd7ca41465c7f05@mail.gmail.com>
Subject: [drm:i915_driver_irq_handler] *ERROR* EIR stuck: 0x00000010, masking
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to my surprise this machine still works...
(dell inspiron 1200)
Anyways in dmesg I see:

[   10.188083] b43-pci-bridge 0000:03:00.0: setting latency timer to 64
[   10.191947] ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
[   10.220248] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
removing generic driver
[   10.222343] Console: switching to colour dummy device 80x25
[   10.225625] Console: switching to colour frame buffer device 128x48
[   10.278714] render error detected, EIR: 0x00000010
[   10.278717] page table error
[   10.278720]   PGTBL_ER: 0x00000100
[   10.278725] [drm:i915_driver_irq_handler] *ERROR* EIR stuck:
0x00000010, masking
[   10.278742] render error detected, EIR: 0x00000010
[   10.278745] page table error
[   10.278747]   PGTBL_ER: 0x00000100
[   10.290087] [drm] LVDS-8: set mode 1024x768 c
[   10.640403] [drm] fb0: inteldrmfb frame buffer device
[   10.640597] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.679818] b43-phy0: Broadcom 4306 WLAN found (core revision 5)

direct rendering still seems to be intact,
suspend not sure(test in a moment).

-- 
Justin P. Mattock
