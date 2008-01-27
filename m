Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYA0JwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYA0JwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbYA0JtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:19 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58943 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755884AbYA0JtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:14 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 15/32] ide-tape: remove struct idetape_block_size_page_t
Date: Sun, 27 Jan 2008 10:48:03 +0100
Message-Id: <1201427300-3954-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 02f5d5e..0708049 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -227,24 +227,6 @@ typedef struct idetape_packet_command_s {
 #define	PC_WRITING			5
 
 /*
- *	Block Size Page
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page code - Should be 0x30 */
-	unsigned	reserved1_6	:1;
-	unsigned	ps		:1;
-	__u8		page_length;		/* Page Length - Should be 2 */
-	__u8		reserved2;
-	unsigned	play32		:1;
-	unsigned	play32_5	:1;
-	unsigned	reserved2_23	:2;
-	unsigned	record32	:1;
-	unsigned	record32_5	:1;
-	unsigned	reserved2_6	:1;
-	unsigned	one		:1;
-} idetape_block_size_page_t;
-
-/*
  *	A pipeline stage.
  */
 typedef struct idetape_stage_s {
-- 
1.5.3.7

