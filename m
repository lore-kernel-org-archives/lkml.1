Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZKHU16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZKHU16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZKHU14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:27:56 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755339AbZKHU0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:26:04 -0500
Subject: [PATCH 20/20] scsi/wd7000: No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       zaga@fly.cc.fer.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:33 -0300
Message-ID: <1257711453.4759.126.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/wd7000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 093610b..764fe89 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1567,7 +1567,7 @@ static int wd7000_release(struct Scsi_Host *shost)
 /*
  *  I have absolutely NO idea how to do an abort with the WD7000...
  */
-static int wd7000_abort(Scsi_Cmnd * SCpnt)
+static int wd7000_abort(struct scsi_cmnd * SCpnt)
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 



