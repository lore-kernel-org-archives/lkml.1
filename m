Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbYFZTg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbYFZTg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbYFZT3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:12 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:27115 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761280AbYFZT3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:04 -0400
X-BigFish: VPS17(zz19c1l19c2kzz10d3izz92fbnz32i43j)
X-WSS-ID: 0K334RU-04-UOH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 34/34] AMD IOMMU: add documentation for kernel parameters
Date: Thu, 26 Jun 2008 21:28:10 +0200
Message-ID: <1214508490-29683-35-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0330 (UTC) FILETIME=[C5DD48A0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the kernel parameters introduced with this driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e07c432..fc8f936 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -271,6 +271,18 @@ and is between 256 and 4096 characters. It is defined in the file
 	aic79xx=	[HW,SCSI]
 			See Documentation/scsi/aic79xx.txt.
 
+	amd_iommu=	[HW,X86-84]
+			Pass parameters to the AMD IOMMU driver in the system.
+			Possible values are:
+			off     - disable the driver for AMD IOMMU
+			isolate - enable device isolation (each device, as far
+			          as possible, will get its own protection
+			          domain)
+	amd_iommu_size= [HW,X86-64]
+			Define the size of the aperture for the AMD IOMMU
+			driver. Possible values are:
+			'32M', '64M' (default), '128M', '256M', '512M', '1G'
+
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
-- 
1.5.3.7


