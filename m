Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYESV5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYESV5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763976AbYESV4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:56:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42007 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758873AbYESV4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:56:24 -0400
Date: Tue, 20 May 2008 00:54:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@gmail.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] pnp: remove printk() with outdated version
Message-ID: <20080519215419.GI17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in printing some ancient version number forever.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
acef517cfbe3cd741f8884311ef6fc2dfbeb1a4d diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 20771b7..d924798 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -209,7 +209,6 @@ void __pnp_remove_device(struct pnp_dev *dev)
 
 static int __init pnp_init(void)
 {
-	printk(KERN_INFO "Linux Plug and Play Support v0.97 (c) Adam Belay\n");
 	return bus_register(&pnp_bus_type);
 }
 

