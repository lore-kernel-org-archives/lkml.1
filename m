Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYA0Jy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYA0Jy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbYA0Jtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:31 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59033 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756117AbYA0JtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:19 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 19/32] ide-tape: remove unused sense packet commands.
Date: Sun, 27 Jan 2008 10:48:07 +0100
Message-Id: <1201427300-3954-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5a18158..fd7eeea 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -577,16 +577,9 @@ struct idetape_id_gcw {
 	unsigned protocol		:2;	/* Protocol type */
 };
 
-/*
- *	Follows structures which are related to the SELECT SENSE / MODE SENSE
- *	packet commands. Those packet commands are still not supported
- *	by ide-tape.
- */
+/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
-#define IDETAPE_PARAMTR_PAGE		0x2b   /* Onstream DI-x0 only */
-#define IDETAPE_BLOCK_SIZE_PAGE		0x30
-#define IDETAPE_BUFFER_FILLING_PAGE	0x33
 
 /*
  *	Run time configurable parameters.
-- 
1.5.3.7

