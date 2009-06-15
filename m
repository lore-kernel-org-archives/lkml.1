Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZFONDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZFONDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZFONDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:03:04 -0400
Received: from legaljet.webserversystems.com ([67.18.134.218]:58472 "EHLO
	compulab.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZFONDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:03:03 -0400
X-Greylist: delayed 3638 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 09:03:03 EDT
Message-ID: <4A363841.5090406@compulab.co.il>
Date: Mon, 15 Jun 2009 15:02:09 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: sameo@linux.intel.com
CC: eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd/da903x: initialize PMIC core early
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,
It'd be great if this can go to 2.6.31

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/mfd/da903x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 7283d88..e5ffe56 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -561,7 +561,7 @@ static int __init da903x_init(void)
 {
 	return i2c_add_driver(&da903x_driver);
 }
-module_init(da903x_init);
+subsys_initcall(da903x_init);

 static void __exit da903x_exit(void)
 {
-- 
1.6.0.6


-- 
Sincerely yours,
Mike.

