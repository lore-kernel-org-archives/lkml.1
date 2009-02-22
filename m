Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZBVALP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZBVALP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZBVAK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:10:58 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53839 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbZBVAK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:10:57 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 08/16] [SCSI] FlashPoint: fix sparse warnings: Using plain
	integer as NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:02:50 +0100
Message-ID: <20090222000242.17557.32246.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
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
 drivers/scsi/FlashPoint.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index cb601cf..9b2ea80 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -903,8 +903,8 @@ static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card);
 static void FPT_autoLoadDefaultMap(unsigned long p_port);
 
 static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
-    { {{0}} };
-static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {0} };
+    { {{NULL}} };
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

