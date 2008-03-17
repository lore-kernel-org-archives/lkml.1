Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYCQGom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYCQGom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbYCQGmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:25 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:30076 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYCQGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=oxj3+Yqbo/PPZkrHkrvne/7PbulksdEfexIKuuhtD7736dYICxDGuY7Ar0wBmtpkFmv/8NkdHfDMHnLbYAtsFwiRFOkepvNv/G+cDyIf/kqY7FajfJYh4VKvY8P0ECTTQmWGgxs9iu+ZVz1iXAuSdupxNDnF9IHvZIvqnFASgw4=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 12/17] ide-tape: remove pipelined mode parameters
Date: Mon, 17 Mar 2008 07:41:25 +0100
Message-Id: <1205736090-4435-13-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0056a26..5535356 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -72,23 +72,6 @@ enum {
 #endif
 
 /**************************** Tunable parameters *****************************/
-
-
-/*
- * Pipelined mode parameters.
- *
- * We try to use the minimum number of stages which is enough to keep the tape
- * constantly streaming. To accomplish that, we implement a feedback loop around
- * the maximum number of stages:
- *
- * We start from MIN maximum stages (we will not even use MIN stages if we don't
- * need them), increment it by RATE*(MAX-MIN) whenever we sense that the
- * pipeline is empty, until we reach the optimum value or until we reach MAX.
- */
-#define IDETAPE_MIN_PIPELINE_STAGES	  1
-#define IDETAPE_MAX_PIPELINE_STAGES	400
-#define IDETAPE_INCREASE_STAGES_RATE	 20
-
 /*
  * After each failed packet command we issue a request sense command and retry
  * the packet command IDETAPE_MAX_PC_RETRIES times.
-- 
1.5.4.1

