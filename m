Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0CAPRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:17:08 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60576 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0CAPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:14 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 02/26] w35und: Remove unused struct _EVENTLOG
Date: Mon,  1 Mar 2010 17:04:04 +0200
Message-Id: <1267455868-4533-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 5626a76..bdce73c 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -110,13 +110,6 @@
 // 20061108 WPS IE buffer
 #define MAX_IE_APPEND_SIZE					256 + 4 // Due to [E id][Length][OUI][Data] may 257 bytes
 
-typedef struct _EVENTLOG
-{
-	u16		Count;			//Total count from start
-	u16		index;			//Buffer index, 0 ~ 63
-	u32		EventValue[64];	//BYTE 3~2 : count, BYTE 1 : Event, BYTE 0 : reason
-} Event_Log, *pEvent_Log;
-
 typedef struct _ChanInfo
 {
 	u8		band;
@@ -264,8 +257,6 @@ typedef struct LOCAL_PARA
     u32         bToSelfPacketReceived;
     u32         WepKeyDetectTimerCount;
 
-	Event_Log	EventLog;
-
 	u16		SignalLostTh;
 	u16		SignalRoamTh;
 
-- 
1.6.3.3

