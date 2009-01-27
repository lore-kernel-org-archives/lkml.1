Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZA0WDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZA0WDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZA0WDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:03:39 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:47441 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751178AbZA0WDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:03:38 -0500
X-YMail-OSG: tJDlf9sVM1mwdgAk6TKKx0pMfdOuaO7vfy.qrixtk1.Wk63Wu0bhTPqWazOlwdfb4FQRXTwzjxP_JFF361BmCvDzIKxKKLvIO44fszTtNO9G2AeuenW33GWaqudStMGZyMHPEYUnHF4WhqN4xddEt4DSv7NQHPtSlYGKx49fy9KufGrwlzWOtWIqaJ_yVt.8SNUnRKTx2W0Qb_5aMEERZk6c3EBHvCop2pX5BjCaw2T7IiNQLvI-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to
	VLC_SA_RECEIVE_CREDENTIAL
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 14:02:29 -0800
Message-Id: <1233093749.6442.97.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9147996b858bc44d8253929fe0cb4acfa9795986 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 13:29:49 -0800
Subject: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to VLC_SA_RECEIVE_CREDENTIAL

This patch adds the VARIABLE_LENGTH_CMD Service Action code:
VLC_SA_RECEIVE_CREDENTIAL and removes the incorrect CDB byte[0]
opcode define RECEIVE_CREDENTIAL.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/scsi/scsi.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 93af6ce..aabd3d1 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -104,7 +104,6 @@
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define VARIABLE_LENGTH_CMD   0x7f
-#define RECEIVE_CREDENTIAL    0x7f // spc4r17 section 6.9 Table 204
 #define REPORT_LUNS           0xa0
 #define SECURITY_PROTOCOL_IN  0xa2
 #define MAINTENANCE_IN        0xa3
@@ -134,6 +133,9 @@
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
+/* values for VARIABLE_LENGTH_CMD service action codes
+ * see spc4r17 Section D.3.5, table D.7 and D.8 */
+#define VLC_SA_RECEIVE_CREDENTIAL 0x1800
 /* values for maintenance in */
 #define MI_REPORT_IDENTIFYING_INFORMATION 0x05
 #define MI_REPORT_TARGET_PGS  0x0a
-- 
1.5.4.1



