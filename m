Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYDUIvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYDUIvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbYDUIuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:50:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41090 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbYDUIuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:50:10 -0400
Date: Mon, 21 Apr 2008 11:49:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/qla2xxx/qla_os.c: make 2 functions static
Message-ID: <20080421084942.GV26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- qla2x00_alloc_work()
- qla2x00_post_work()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

e65698d54a14771ffd54797e87790a00aa7d1e0a diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8b33b16..d2dfd08 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2135,7 +2135,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	kfree(ha->nvram);
 }
 
-struct qla_work_evt *
+static struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
     int locked)
 {
@@ -2152,7 +2152,7 @@ qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
 	return e;
 }
 
-int
+static int
 qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
 {
 	unsigned long flags;

