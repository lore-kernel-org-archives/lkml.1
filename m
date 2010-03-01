Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0CAPOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:14:39 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:57864 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0CAPOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:34 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 11/26] w35und: Remove unused header file scan_s.h
Date: Mon,  1 Mar 2010 17:04:13 +0200
Message-Id: <1267455868-4533-11-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mds_s.h  |    1 -
 drivers/staging/winbond/scan_s.h |   65 --------------------------------------
 2 files changed, 0 insertions(+), 66 deletions(-)
 delete mode 100644 drivers/staging/winbond/scan_s.h

diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index 217ff08..2b1f3a6 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -7,7 +7,6 @@
 
 #include "localpara.h"
 #include "mac_structures.h"
-#include "scan_s.h"
 
 /* Preamble_Type, see <SFS-802.11G-MIB-203> */
 enum {
diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
deleted file mode 100644
index a577884..0000000
--- a/drivers/staging/winbond/scan_s.h
+++ /dev/null
@@ -1,65 +0,0 @@
-#ifndef __WINBOND_SCAN_S_H
-#define __WINBOND_SCAN_S_H
-
-#include <linux/types.h>
-#include "localpara.h"
-
-//
-// SCAN task global CONSTANTS, STRUCTURES, variables
-//
-
-//////////////////////////////////////////////////////////////////////////
-//define the msg type of SCAN module
-#define SCANMSG_SCAN_REQ			0x01
-#define SCANMSG_BEACON				0x02
-#define SCANMSG_PROBE_RESPONSE		0x03
-#define SCANMSG_TIMEOUT				0x04
-#define SCANMSG_TXPROBE_FAIL		0x05
-#define SCANMSG_ENABLE_BGSCAN		0x06
-#define SCANMSG_STOP_SCAN			0x07
-
-// BSS Type =>conform to
-// IBSS             : ToDS/FromDS = 00
-// Infrastructure   : ToDS/FromDS = 01
-#define IBSS_NET			0
-#define ESS_NET				1
-#define ANYBSS_NET			2
-
-// Scan Type
-#define ACTIVE_SCAN			0
-#define PASSIVE_SCAN		1
-
-///////////////////////////////////////////////////////////////////////////
-//Global data structures, Initial Scan & Background Scan
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	scan.h
-//		Define the related definitions of scan module
-//	history -- 01/14/03' created
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-
-//Define the state of scan module
-#define SCAN_INACTIVE						0
-#define WAIT_PROBE_DELAY					1
-#define WAIT_RESPONSE_MIN					2
-#define WAIT_RESPONSE_MAX_ACTIVE			3
-#define WAIT_BEACON_MAX_PASSIVE				4
-#define SCAN_COMPLETE						5
-#define BG_SCAN								6
-#define BG_SCANNING							7
-
-
-// The value will load from EEPROM
-// If 0xff is set in EEPOM, the driver will use SCAN_MAX_CHNL_TIME instead.
-// The definition is in WbHal.h
-//	#define SCAN_MAX_CHNL_TIME				(50)
-
-
-
-// static functions
-
-//static void ScanTimerHandler(struct wbsoft_priv * adapter);
-//static void vScanTimerStart(struct wbsoft_priv *	adapter, int timeout_value);
-//static void vScanTimerStop(struct wbsoft_priv * adapter);
-
-#endif
-- 
1.6.3.3

