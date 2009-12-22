Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZLVI1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZLVI1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZLVI1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:27:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:33877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750991AbZLVI1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:27:14 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/N84xMPzDNV5nL5dPdiY6sLPu1YCUu+TPlnZQ5vl
	jRuaSEblQMkIUk
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] uwb/i1480: add __init/__exit macros
Date: Tue, 22 Dec 2009 09:27:05 +0100
Message-Id: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

uwb/i1480/i1480-est.c

@Jiri: As there is no maintainer, it seems it is up to you to decide :)

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/uwb/i1480/i1480-est.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uwb/i1480/i1480-est.c b/drivers/uwb/i1480/i1480-est.c
index 7bf8c6f..f2eb4d8 100644
--- a/drivers/uwb/i1480/i1480-est.c
+++ b/drivers/uwb/i1480/i1480-est.c
@@ -54,7 +54,7 @@ static struct uwb_est_entry i1480_est_fd01[] = {
 		.size = sizeof(struct i1480_rceb) + 2 },
 };
 
-static int i1480_est_init(void)
+static int __init i1480_est_init(void)
 {
 	int result = uwb_est_register(i1480_CET_VS1, 0x00, 0x8086, 0x0c3b,
 				      i1480_est_fd00,
@@ -73,7 +73,7 @@ static int i1480_est_init(void)
 }
 module_init(i1480_est_init);
 
-static void i1480_est_exit(void)
+static void __exit i1480_est_exit(void)
 {
 	uwb_est_unregister(i1480_CET_VS1, 0x00, 0x8086, 0x0c3b,
 			   i1480_est_fd00, ARRAY_SIZE(i1480_est_fd00));
-- 
1.6.4.4

