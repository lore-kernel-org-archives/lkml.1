Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXKLFhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXKLFhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 00:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXKLFha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 00:37:30 -0500
Received: from ozlabs.org ([203.10.76.45]:51943 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXKLFha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 00:37:30 -0500
To: <linux-kernel@vger.kernel.org>
CC: <cbe-oss-dev@ozlabs.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 12 Nov 2007 16:36:52 +1100
Subject: [RFC/PATCH] Export force_sig_info
Message-Id: <1194845812.531937.269801315194.qpush@pokey>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This change allows force_sig_info to be called from modules.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

--

Any objections to exporting this symbol? I'm  planning to move some
SPU fault-handling code from the kernel to the spufs.ko object.

---

 kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-spufs/kernel/signal.c
===================================================================
--- linux-2.6-spufs.orig/kernel/signal.c
+++ linux-2.6-spufs/kernel/signal.c
@@ -815,6 +815,7 @@ force_sig_info(int sig, struct siginfo *
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(force_sig_info);
 
 void
 force_sig_specific(int sig, struct task_struct *t)
