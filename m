Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYC3XNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYC3XNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbYC3XM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:12:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53918 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684AbYC3XM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:12:56 -0400
Date: Mon, 31 Mar 2008 02:12:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ipmi_alloc_recv_msg() static
Message-ID: <20080330231243.GD28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global ipmi_alloc_recv_msg() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2a99aad0e15f482da6e0f34fa3005d4574a1a8a9 diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 32b2b22..63171d7 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3789,7 +3789,7 @@ static void free_recv_msg(struct ipmi_recv_msg *msg)
 	kfree(msg);
 }
 
-struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
+static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
 {
 	struct ipmi_recv_msg *rv;
 

