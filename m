Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZKHU0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZKHU0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZKHU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:26:09 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755362AbZKHU0H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:26:07 -0500
Subject: [PATCH 17/20] scsi/pas16: No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       drew@colorado.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:28 -0300
Message-ID: <1257711448.4759.123.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/pas16.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
index 8dc5b1a..dc87366 100644
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -114,12 +114,12 @@
 

 #ifndef ASM
-static int pas16_abort(Scsi_Cmnd *);
+static int pas16_abort(struct scsi_cmnd *);
 static int pas16_biosparam(struct scsi_device *, struct block_device *,
 			   sector_t, int*);
 static int pas16_detect(struct scsi_host_template *);
-static int pas16_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int pas16_bus_reset(Scsi_Cmnd *);
+static int pas16_queue_command(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int pas16_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2



