Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbZCYSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbZCYSWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbZCYSWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:22:04 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:34872 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbZCYSWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:22:02 -0400
X-Greylist: delayed 1133 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 14:22:01 EDT
Date: Wed, 25 Mar 2009 18:00:50 +0000
From: Colin Watson <cjwatson@canonical.com>
To: device@lanana.org
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: [PATCH] Document MMC block device numbers
Message-ID: <20090325180050.GY7367@riva.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Originating-Smarthost02-IP: [82.69.40.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MMC block devices created by drivers/mmc/card/block.c in mainline do
not appear to be documented in Documentation/devices.txt. This patch
documents them.

Signed-off-by: Colin Watson <cjwatson@canonical.com>
---
 Documentation/devices.txt |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 2be0824..4a3343f 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2547,6 +2547,19 @@ Your cooperation is appreciated.
 		  1 = /dev/dvxirq1	Second DVX device
 		    ...
 
+179 block	MMC block devices
+		  0 = /dev/mmcblk0	First MMC block device
+		  8 = /dev/mmcblk1	Second MMC block device
+		    ...
+		248 = /dev/mmcblk32	32nd MMC block device
+
+		For each device, partitions are added as:
+		  0 = /dev/mmcblk?	Whole disk
+		  1 = /dev/mmcblk?p1	First partition
+		  2 = /dev/mmcblk?p2	Second partition
+		    ...
+		  7 = /dev/mmcblk?p7	Seventh partition
+
 180 char	USB devices
 		  0 = /dev/usb/lp0	First USB printer
 		    ...
-- 
1.6.0.4


-- 
Colin Watson                                    [cjwatson@canonical.com]
