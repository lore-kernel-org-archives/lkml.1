Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbZLVIiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbZLVIiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZLVIiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:38:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:41776 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750896AbZLVIiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:38:05 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18OY7Bk0VMOl85DBP82SFcjbF5fLR3NDlAH/xgb5O
	0731MkPOIf4jtE
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] w1: add __init/__exit macros to drivers/w1/w1.c
Date: Tue, 22 Dec 2009 09:38:02 +0100
Message-Id: <1261471082-24233-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/w1/w1.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/w1/w1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index acc7e3b..ad5897d 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -986,7 +986,7 @@ int w1_process(void *data)
 	return 0;
 }
 
-static int w1_init(void)
+static int __init w1_init(void)
 {
 	int retval;
 
@@ -1034,7 +1034,7 @@ err_out_exit_init:
 	return retval;
 }
 
-static void w1_fini(void)
+static void __exit w1_fini(void)
 {
 	struct w1_master *dev;
 
-- 
1.6.4.4

