Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZBUWn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZBUWn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 17:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZBUWnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 17:43:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:14270 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbZBUWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 17:43:16 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH] aty128fb: remove unused variable 'pwr_command'
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Feb 2009 23:43:11 +0100
Message-ID: <20090221224252.5684.79344.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warning:
  drivers/video/aty/aty128fb.c:2368: warning: unused variable 'pwr_command'

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/video/aty/aty128fb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index ea5b193..e912258 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -2365,7 +2365,6 @@ static void fbcon_aty128_bmove(struct display *p, int sy, int sx, int dy, int dx
 static void aty128_set_suspend(struct aty128fb_par *par, int suspend)
 {
 	u32	pmgt;
-	u16	pwr_command;
 	struct pci_dev *pdev = par->pdev;
 
 	if (!par->pm_reg)

