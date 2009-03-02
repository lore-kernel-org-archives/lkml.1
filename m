Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZCBVfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZCBVfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZCBVf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:35:28 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:34246 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZCBVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:35:27 -0500
From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 02 Mar 2009 22:34:37 +0100
Message-ID: <20090302213436.27388.13985.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11/16 v2] NULL noise: drivers/ide/ide-*.c
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090227012837.GQ28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/ide/ide-disk_proc.c:130:11: warning: Using plain integer as NULL pointer
  drivers/ide/ide-floppy_proc.c:32:11: warning: Using plain integer as NULL pointer
  drivers/ide/ide-proc.c:234:11: warning: Using plain integer as NULL pointer
  drivers/ide/ide-tape.c:2141:11: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 drivers/ide/ide-disk_proc.c   |    2 +-
 drivers/ide/ide-floppy_proc.c |    2 +-
 drivers/ide/ide-proc.c        |    2 +-
 drivers/ide/ide-tape.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
index 3f2a078..eaea3be 100644
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -127,5 +127,5 @@ const struct ide_proc_devset ide_disk_settings[] = {
 	IDE_PROC_DEVSET(multcount,	0,    16),
 	IDE_PROC_DEVSET(nowerr,		0,     1),
 	IDE_PROC_DEVSET(wcache,		0,     1),
-	{ 0 },
+	{ NULL },
 };
diff --git a/drivers/ide/ide-floppy_proc.c b/drivers/ide/ide-floppy_proc.c
index 3ec762c..fcd4d81 100644
--- a/drivers/ide/ide-floppy_proc.c
+++ b/drivers/ide/ide-floppy_proc.c
@@ -29,5 +29,5 @@ const struct ide_proc_devset ide_floppy_settings[] = {
 	IDE_PROC_DEVSET(bios_head, 0,  255),
 	IDE_PROC_DEVSET(bios_sect, 0,   63),
 	IDE_PROC_DEVSET(ticks,	   0,  255),
-	{ 0 },
+	{ NULL },
 };
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 0ee8887..10a88bf 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -231,7 +231,7 @@ static const struct ide_proc_devset ide_generic_settings[] = {
 	IDE_PROC_DEVSET(pio_mode, 0, 255),
 	IDE_PROC_DEVSET(unmaskirq, 0, 1),
 	IDE_PROC_DEVSET(using_dma, 0, 1),
-	{ 0 },
+	{ NULL },
 };
 
 static void proc_ide_settings_warn(void)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 733cb51..cafc67d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2142,7 +2142,7 @@ static const struct ide_proc_devset idetape_settings[] = {
 	__IDE_PROC_DEVSET(speed,	0, 0xffff, NULL, NULL),
 	__IDE_PROC_DEVSET(tdsc,		IDETAPE_DSC_RW_MIN, IDETAPE_DSC_RW_MAX,
 					mulf_tdsc, divf_tdsc),
-	{ 0 },
+	{ NULL },
 };
 #endif
 

