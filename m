Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZKHUZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZKHUZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZKHUZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:25:37 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754554AbZKHUZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:25:37 -0500
Subject: [PATCH 12/20] scsi/gdth_proc: No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:19 -0300
Message-ID: <1257711439.4759.118.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/gdth_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 1258da3..74e44ed 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -726,7 +726,7 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
     ulong flags;
     int i;
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     struct gdth_cmndinfo *cmndinfo;
     unchar b, t;
 



