Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZEJFc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZEJFc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 01:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZEJFce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 01:32:34 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:60525 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZEJFcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 01:32:33 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: gustavo@padovan.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Add case for Enhanced Retransmission and Streaming modes
Date: Sun, 10 May 2009 02:29:32 -0300
Message-Id: <1241933373-24083-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just add return values on mode2str for the new modes on L2CAP
---
 parser/l2cap.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/parser/l2cap.c b/parser/l2cap.c
index a906f42..4ab4123 100644
--- a/parser/l2cap.c
+++ b/parser/l2cap.c
@@ -306,6 +306,10 @@ static char *mode2str(uint8_t mode)
 		return "Retransmission";
 	case 0x02:
 		return "Flow control";
+	case 0x03:
+		return "Enhanced Retransmission";
+	case 0x04:
+		return "Streaming";
 	default:
 		return "Reserved";
 	}
-- 
1.6.0.6

