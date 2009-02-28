Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZB1FEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZB1FEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbZB1FDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:03:48 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45715 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZB1FDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:03:47 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] bluetooth: add macros for cid channel numbers
Date: Sat, 28 Feb 2009 02:02:26 -0300
Message-Id: <1235797347-1816-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 include/net/bluetooth/l2cap.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index f566aa1..e7bf331 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -118,6 +118,13 @@ struct l2cap_conn_rsp {
 #define L2CAP_CS_AUTHEN_PEND  0x0001
 #define L2CAP_CS_AUTHOR_PEND  0x0002
 
+
+/* cid channel type */
+#define L2CAP_CID_SIGNALING	0x0001
+#define L2CAP_CID_CONN_LESS	0x0002
+#define L2CAP_CID_DYN_START	0x0040
+#define L2CAP_CID_DYN_END	0xffff
+
 struct l2cap_conf_req {
 	__le16     dcid;
 	__le16     flags;
-- 
1.6.0.6

