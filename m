Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXJPAaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXJPAaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbXJPA3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:29:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44625 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXJPA3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:29:52 -0400
Date: Mon, 15 Oct 2007 17:29:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
       Eric.Moore@lsi.com, scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/4] docbook: fix kernel-api content
Message-Id: <20071015172933.80ab7d1d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-api docbook warnings.

Warning(linux-2.6.23-git8//drivers/message/fusion/mptscsih.c:2618): No description found for parameter 'sc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/message/fusion/mptscsih.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- linux-2.6.23-git8.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.23-git8/drivers/message/fusion/mptscsih.c
@@ -2605,14 +2605,10 @@ mptscsih_set_scsi_lookup(MPT_ADAPTER *io
 }
 
 /**
- * SCPNT_TO_LOOKUP_IDX
- *
- * search's for a given scmd in the ScsiLookup[] array list
- *
+ * SCPNT_TO_LOOKUP_IDX - searches for a given scmd in the ScsiLookup[] array list
  * @ioc: Pointer to MPT_ADAPTER structure
- * @scmd: scsi_cmnd pointer
- *
- **/
+ * @sc: scsi_cmnd pointer
+ */
 static int
 SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, struct scsi_cmnd *sc)
 {
