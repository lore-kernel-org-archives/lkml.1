Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYHFVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYHFVMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYHFVLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:11:55 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47607 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422746AbYHFVLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:11:52 -0400
Date: Thu, 7 Aug 2008 00:10:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rene Herman <rene.herman@gmail.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Adam M Belay <abelay@MIT.EDU>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] pnp: remove printk() with outdated version
Message-ID: <20080806211023.GD1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in printing some ancient version number forever.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by; Rene Herman <rene.herman@gmail.com>
Acked-by; Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by; Adam M Belay <abelay@MIT.EDU>

---

This patch has been sent on:
- 20 May 2008

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
 

