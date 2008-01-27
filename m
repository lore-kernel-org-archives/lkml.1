Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbYA0Jvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbYA0Jvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYA0JtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:14 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58878 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755813AbYA0JtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:11 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 11/32] ide-tape: remove struct idetape_data_compression_page_t
Date: Sun, 27 Jan 2008 10:47:59 +0100
Message-Id: <1201427300-3954-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

There should be no functional changes resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 9f1fc50..0c3ec66 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -676,25 +676,6 @@ typedef struct {
 } idetape_parameter_block_descriptor_t;
 
 /*
- *	The Data Compression Page, as returned by the MODE SENSE packet command.
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page Code - Should be 0xf */
-	unsigned	reserved0	:1;	/* Reserved */
-	unsigned	ps		:1;
-	__u8		page_length;		/* Page Length - Should be 14 */
-	unsigned	reserved2	:6;	/* Reserved */
-	unsigned	dcc		:1;	/* Data Compression Capable */
-	unsigned	dce		:1;	/* Data Compression Enable */
-	unsigned	reserved3	:5;	/* Reserved */
-	unsigned	red		:2;	/* Report Exception on Decompression */
-	unsigned	dde		:1;	/* Data Decompression Enable */
-	__u32		ca;			/* Compression Algorithm */
-	__u32		da;			/* Decompression Algorithm */
-	__u8		reserved[4];		/* Reserved */
-} idetape_data_compression_page_t;
-
-/*
  *	The Medium Partition Page, as returned by the MODE SENSE packet command.
  */
 typedef struct {
-- 
1.5.3.7

