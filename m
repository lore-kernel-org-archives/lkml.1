Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZKHU0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZKHU0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZKHU0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:26:13 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755384AbZKHU0L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:26:11 -0500
Subject: [PATCH 08/20] scsi/dtc: No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       drew@colorado.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:12 -0300
Message-ID: <1257711432.4759.114.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/dtc.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
index 0b205f8..524b711 100644
--- a/drivers/scsi/dtc.h
+++ b/drivers/scsi/dtc.h
@@ -32,12 +32,12 @@
 #define DTCDEBUG_INIT	0x1
 #define DTCDEBUG_TRANSFER 0x2
 
-static int dtc_abort(Scsi_Cmnd *);
+static int dtc_abort(struct scsi_cmnd *);
 static int dtc_biosparam(struct scsi_device *, struct block_device *,
 		         sector_t, int*);
 static int dtc_detect(struct scsi_host_template *);
-static int dtc_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int dtc_bus_reset(Scsi_Cmnd *);
+static int dtc_queue_command(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int dtc_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2




