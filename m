Return-Path: <linux-kernel-owner+w=401wt.eu-S1762731AbYCAJJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762731AbYCAJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYCAI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:51 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:13335 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbYCAI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=temntacRUVcWSHO7lmwe3G1U1oJ+K+b24jcuo8pPOV0vg6H1nIS+t3iMNijoN4UqGcQQIoBwwSXyZuIOpJ8OmC3pZMsO7jQ0l5cQKc/w8NzoYf0jnyF46zpNPp86gHnriOttZ6O372YUbyHXPacS9cv4xK/D3oOsWB9CfnJnW/I=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 19/24] ide-tape: remove pipelined mode parameters
Date: Sat,  1 Mar 2008 09:58:43 +0100
Message-Id: <1204361928-30229-20-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 2718006..a5f29ea 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -75,24 +75,6 @@ enum {
 
 
 /*
- * Pipelined mode parameters.
- *
- * We try to use the minimum number of stages which is enough to keep the tape
- * constantly streaming. To accomplish that, we implement a feedback loop around
- * the maximum number of stages:
- *
- * We start from MIN maximum stages (we will not even use MIN stages if we don't
- * need them), increment it by RATE*(MAX-MIN) whenever we sense that the
- * pipeline is empty, until we reach the optimum value or until we reach MAX.
- *
- * Setting the following parameter to 0 is illegal: the pipelined mode cannot be
- * disabled (idetape_calculate_speeds() divides by tape->max_stages.)
- */
-#define IDETAPE_MIN_PIPELINE_STAGES	  1
-#define IDETAPE_MAX_PIPELINE_STAGES	400
-#define IDETAPE_INCREASE_STAGES_RATE	 20
-
-/*
  * After each failed packet command we issue a request sense command and retry
  * the packet command IDETAPE_MAX_PC_RETRIES times.
  *
-- 
1.5.4.1

