Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378Ab0AVXaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0AVXaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823Ab0AVX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:29:58 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:51452 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab0AVX34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:29:56 -0500
Message-Id: <445e1bf881b6f8b6a5886d6eee70f6435a5619d6.1264201408.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Date: Sun, 10 Jan 2010 14:21:31 +0100
Subject: [PATCH 31/31] CAPI: Officially claim char major 191
X-Provags-ID: V01U2FsdGVkX19qd7t30joIucvytpLp877UKpepSLhBhtPZERJN
	6O+5MC69scx46gd5X7JXNbwuYFR3R33rLdHMLo2yfqvvw/C3SQ
	ERWrOkLOU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found no trace of this mysterious "pcl181" device, neither in-tree nor
out there in the wild. At the same time, the in-tree CAPI middleware is
using major 191 for many years now and obviously without any conflict.
Let's officially claim this major number.

CC: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 Documentation/devices.txt |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 53d64d3..4dfc2a0 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -403,7 +403,7 @@ Your cooperation is appreciated.
 		188 = /dev/smbusbios	SMBus BIOS
 		189 = /dev/ussp_ctl	User space serial port control
 		190 = /dev/crash	Mission Critical Linux crash dump facility
-		191 = /dev/pcl181	<information missing>
+		191 = /dev/capi/[0-9]*	CAPI 2.0 middleware, NCCI TTYs
 		192 = /dev/nas_xbus	NAS xbus LCD/buttons access
 		193 = /dev/d7s		SPARC 7-segment display
 		194 = /dev/zkshim	Zero-Knowledge network shim control
@@ -2618,7 +2618,10 @@ Your cooperation is appreciated.
 		  1 = /dev/kctt1	Second KCT/T card
 		    ...
 
-191 char	Reserved for PCMCIA
+191 char	CAPI 2.0 middleware, NCCI TTYs
+		  0 = /dev/capi/0	TTY for NCCI ID 0
+		  1 = /dev/capi/1	TTY for NCCI ID 1
+		    ...
 
 192 char	Kernel profiling interface
 		  0 = /dev/profile	Profiling control device
-- 
1.6.0.2
