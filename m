Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbZLRVI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbZLRVI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932868AbZLRVIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:08:25 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:43058 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbZLRVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:08:25 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 3/8] w35und: Remove unused typedef _EVENTLOG
Date: Fri, 18 Dec 2009 23:08:17 +0200
Message-Id: <1261170502-1479-3-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261170502-1479-2-git-send-email-penberg@cs.helsinki.fi>
References: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-2-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index b82d5ce..6b29b56 100644
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
@@ -264,8 +257,6 @@ struct wb_local_para
     u32         bToSelfPacketReceived;
     u32         WepKeyDetectTimerCount;
 
-	Event_Log	EventLog;
-
 	u16		SignalLostTh;
 	u16		SignalRoamTh;
 
-- 
1.6.0.4

