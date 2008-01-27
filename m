Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYA0Jwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYA0Jwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbYA0JtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:20 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58942 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755934AbYA0JtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:14 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 14/32] ide-tape: remove structs os_partition_t, os_dat_entry_t, os_dat_t
Date: Sun, 27 Jan 2008 10:48:02 +0100
Message-Id: <1201427300-3954-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

They seem just to sit there completely unused.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ea69183..02f5d5e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -42,43 +42,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/unaligned.h>
-
-/*
- * partition
- */
-typedef struct os_partition_s {
-	__u8	partition_num;
-	__u8	par_desc_ver;
-	__u16	wrt_pass_cntr;
-	__u32	first_frame_addr;
-	__u32	last_frame_addr;
-	__u32	eod_frame_addr;
-} os_partition_t;
-
-/*
- * DAT entry
- */
-typedef struct os_dat_entry_s {
-	__u32	blk_sz;
-	__u16	blk_cnt;
-	__u8	flags;
-	__u8	reserved;
-} os_dat_entry_t;
-
-/*
- * DAT
- */
-#define OS_DAT_FLAGS_DATA	(0xc)
-#define OS_DAT_FLAGS_MARK	(0x1)
-
-typedef struct os_dat_s {
-	__u8		dat_sz;
-	__u8		reserved1;
-	__u8		entry_cnt;
-	__u8		reserved3;
-	os_dat_entry_t	dat_list[16];
-} os_dat_t;
-
 #include <linux/mtio.h>
 
 /**************************** Tunable parameters *****************************/
-- 
1.5.3.7

