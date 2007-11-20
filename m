Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbXKTB5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbXKTB5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbXKTBtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:43 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2088 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbXKTBtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:11 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <kkeil@suse.de>, isdn4linux@listserv.isdn4linux.de
Subject: [PATCH 21/59] drivers/isdn: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:13 -0800
Message-Id: <1195523331-15303-22-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-21-git-send-email-joe@perches.com>
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
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
Message-Id: <d82909a235a0ca88319aaf7990fc94f7ebb649bb.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/i4l/isdn_ppp.c      |    2 +-
 drivers/isdn/i4l/isdn_x25iface.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index 9f5fe37..742e0f6 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -2472,7 +2472,7 @@ static void isdn_ppp_ccp_reset_ack_rcvd(struct ippp_struct *is,
 				       " for id %d but not expected\n", id);
 		} else {
 			printk(KERN_INFO "ippp_ccp: ResetAck received out of"
-			       "sync for id %d\n", id);
+			       " sync for id %d\n", id);
 		}
 		if(rs->ta) {
 			rs->ta = 0;
diff --git a/drivers/isdn/i4l/isdn_x25iface.c b/drivers/isdn/i4l/isdn_x25iface.c
index 8b3efc2..a2121c1 100644
--- a/drivers/isdn/i4l/isdn_x25iface.c
+++ b/drivers/isdn/i4l/isdn_x25iface.c
@@ -65,7 +65,7 @@ static struct concap_proto_ops ix25_pops = {
 /* error message helper function */
 static void illegal_state_warn( unsigned state, unsigned char firstbyte) 
 {
-	printk( KERN_WARNING "isdn_x25iface: firstbyte %x illegal in"
+	printk( KERN_WARNING "isdn_x25iface: firstbyte %x illegal in "
 		"current state %d\n",firstbyte, state );
 }
 
-- 
1.5.3.5.652.gf192c

