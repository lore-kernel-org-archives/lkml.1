Return-Path: <linux-kernel-owner+w=401wt.eu-S1764844AbYEAATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764844AbYEAATi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYEAATa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:19:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28291 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYEAAT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:19:29 -0400
Date: Wed, 30 Apr 2008 17:18:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] PNP: fix missing kernel-doc notation
Message-Id: <20080430171818.65513bcf.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix missing PNP kernel-doc notation:

Warning(linux-2.6.25-git16//drivers/pnp/manager.c:261): No description found for parameter 'dev'
Warning(linux-2.6.25-git16//drivers/pnp/manager.c:292): No description found for parameter 'dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pnp/manager.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.25-git16.orig/drivers/pnp/manager.c
+++ linux-2.6.25-git16/drivers/pnp/manager.c
@@ -255,7 +255,7 @@ void pnp_init_resource(struct resource *
 
 /**
  * pnp_init_resources - Resets a resource table to default values.
- * @table: pointer to the desired resource table
+ * @dev: pointer to the owning &pnp_dev
  */
 void pnp_init_resources(struct pnp_dev *dev)
 {
@@ -286,7 +286,7 @@ void pnp_init_resources(struct pnp_dev *
 
 /**
  * pnp_clean_resources - clears resources that were not manually set
- * @res: the resources to clean
+ * @dev: &pnp_dev for the resources to clean
  */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
