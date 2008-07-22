Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYGVRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYGVRVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYGVRUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:20:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59881 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbYGVRUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:20:32 -0400
Date: Tue, 22 Jul 2008 20:20:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ambx1@neo.rr.com, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make pnp_build_option() static
Message-ID: <20080722172021.GN14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_build_optionq() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
87ec46ea755fc5349371bf2208b30264da355699 
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 4cfe3a1..2e5b7eb 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -30,8 +30,9 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
  * option registration
  */
 
-struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
-				    unsigned int option_flags)
+static struct pnp_option *pnp_build_option(struct pnp_dev *dev,
+					   unsigned long type,
+					   unsigned int option_flags)
 {
 	struct pnp_option *option;
 

