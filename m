Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbXJ1Pvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbXJ1Pvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXJ1Pv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:51:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60000 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbXJ1Pv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:51:28 -0400
Date: Sun, 28 Oct 2007 16:51:42 +0100
From: Adrian Bunk <bunk@kernel.org>
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/seagate.c: remove dead code
Message-ID: <20071028155142.GB7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes obviously dead code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/seagate.c |    2 --
 1 file changed, 2 deletions(-)

c0807bbefb65ef679b7d2ec13d14c35f2e927404 
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index b113244..2d31ed4 100644
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -1437,17 +1437,15 @@ connect_loop:
 					break;
 #ifdef LINKED
 				case LINKED_WRONG:
 					WRITE_DATA (ABORT);
 					linked_connected = 0;
 					reselect = CAN_RECONNECT;
 					goto connect_loop;
-					DPRINTK (PHASE_MSGOUT | DEBUG_LINKED, "scsi%d : sent ABORT message to cancel incorrect I_T_L nexus.\n", hostno);
 #endif					/* LINKED */
-					DPRINTK (DEBUG_LINKED, "correct\n");
 				default:
 					WRITE_DATA (NOP);
 					printk("scsi%d : target %d requested MSGOUT, sent NOP message.\n", hostno, target);
 				}
 				break;
 
 			case REQ_MSGIN:

