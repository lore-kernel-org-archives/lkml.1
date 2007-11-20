Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbXKTB4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbXKTB4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbXKTBtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:32 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2078 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbXKTBtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:06 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Collins <ben.collins@ubuntu.com>, Dan Dennedy <dan@dennedy.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net
Subject: [PATCH 18/59] drivers/ieee1394: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:10 -0800
Message-Id: <1195523331-15303-19-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-18-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
Message-Id: <00c276347dd7ef0da4abbb8e7f2c0aa776e685c2.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ieee1394/raw1394.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index cadf047..37e7e10 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -858,7 +858,7 @@ static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
 	int found = 0, size = 0, rcode = -1;
 	struct arm_request_response *arm_req_resp = NULL;
 
-	DBGMSG("arm_read  called by node: %X"
+	DBGMSG("arm_read  called by node: %X "
 	       "addr: %4.4x %8.8x length: %Zu", nodeid,
 	       (u16) ((addr >> 32) & 0xFFFF), (u32) (addr & 0xFFFFFFFF),
 	       length);
@@ -1012,7 +1012,7 @@ static int arm_write(struct hpsb_host *host, int nodeid, int destid,
 	int found = 0, size = 0, rcode = -1, length_conflict = 0;
 	struct arm_request_response *arm_req_resp = NULL;
 
-	DBGMSG("arm_write called by node: %X"
+	DBGMSG("arm_write called by node: %X "
 	       "addr: %4.4x %8.8x length: %Zu", nodeid,
 	       (u16) ((addr >> 32) & 0xFFFF), (u32) (addr & 0xFFFFFFFF),
 	       length);
-- 
1.5.3.5.652.gf192c

