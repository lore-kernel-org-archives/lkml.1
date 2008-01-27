Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbYA0Jvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbYA0Jvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYA0JtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:18 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58931 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755900AbYA0JtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:13 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 12/32] ide-tape: remove struct idetape_medium_partition_page_t
Date: Sun, 27 Jan 2008 10:48:00 +0100
Message-Id: <1201427300-3954-7-git-send-email-petkovbb@gmail.com>
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
index 0c3ec66..ed53e7f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -676,25 +676,6 @@ typedef struct {
 } idetape_parameter_block_descriptor_t;
 
 /*
- *	The Medium Partition Page, as returned by the MODE SENSE packet command.
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page Code - Should be 0x11 */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	ps		:1;
-	__u8		page_length;		/* Page Length - Should be 6 */
-	__u8		map;			/* Maximum Additional Partitions - Should be 0 */
-	__u8		apd;			/* Additional Partitions Defined - Should be 0 */
-	unsigned	reserved4_012	:3;	/* Reserved */
-	unsigned	psum		:2;	/* Should be 0 */
-	unsigned	idp		:1;	/* Should be 0 */
-	unsigned	sdp		:1;	/* Should be 0 */
-	unsigned	fdp		:1;	/* Fixed Data Partitions */
-	__u8		mfr;			/* Medium Format Recognition */
-	__u8		reserved[2];		/* Reserved */
-} idetape_medium_partition_page_t;
-
-/*
  *	Run time configurable parameters.
  */
 typedef struct {
-- 
1.5.3.7

