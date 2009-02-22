Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZBVAMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZBVAMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZBVALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:11:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:53120 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbZBVALs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:11:48 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 08/16 v2] [SCSI] FlashPoint: fix sparse warnings: Using plain
	integer as NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:11:42 +0100
Message-ID: <20090222001036.18094.45698.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090222000242.17557.32246.stgit@vmbox.hanneseder.net>
References: <20090222000242.17557.32246.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
  drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
  drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: fix checkpatch.pl issue.

 drivers/scsi/FlashPoint.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index cb601cf..61e268e 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -903,8 +903,8 @@ static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card);
 static void FPT_autoLoadDefaultMap(unsigned long p_port);
 
 static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
-    { {{0}} };
-static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {0} };
+    { { {NULL} } };
+static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {NULL} };
 static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { {{0}} };
 static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { {0} };
 
@@ -918,8 +918,7 @@ static unsigned char FPT_scamHAString[] =
 
 static unsigned short FPT_default_intena = 0;
 
-static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {
-0};
+static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {NULL};
 
 /*---------------------------------------------------------------------
  *

