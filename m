Return-Path: <linux-kernel-owner+w=401wt.eu-S935585AbXLQCgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935585AbXLQCgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935372AbXLQCgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:36:05 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39641 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935359AbXLQCgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:36:02 -0500
Date: Mon, 17 Dec 2007 03:36:00 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071217023600.24944.84644.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071217023555.24944.62155.sendpatchset@thinktank.campus.ltu.se>
References: <20071217023555.24944.62155.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 2/3] msg.h: Convert m_ts from int to size_t.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert m_ts ("message text size") from int to size_t.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Remove some trailing spaces, since we are in the neighborhood.


diff --git a/include/linux/msg.h b/include/linux/msg.h
index 10a3d5a..7a61952 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -67,8 +67,8 @@ struct msginfo {
 /* one msg_msg structure for each message */
 struct msg_msg {
 	struct list_head m_list; 
-	long  m_type;          
-	int m_ts;           /* message text size */
+	long  m_type;
+	size_t m_ts;           /* message text size */
 	struct msg_msgseg* next;
 	void *security;
 	/* the actual message follows immediately */
