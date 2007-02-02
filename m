Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbXBBDsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbXBBDsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 22:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXBBDsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 22:48:08 -0500
Received: from mout1.freenet.de ([194.97.50.132]:45416 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbXBBDsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 22:48:07 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] Make rcupreempt.c compile with CONFIG_RCU_TRACE not set
Date: Fri, 2 Feb 2007 04:48:02 +0100
User-Agent: KMail/1.9.5
References: <200701300131.36485.fzu@wemgehoertderstaat.de> <20070201020619.GU2574@linux.vnet.ibm.com> <200702011106.13836.fzu@wemgehoertderstaat.de>
In-Reply-To: <200702011106.13836.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702020448.03256.fzu@wemgehoertderstaat.de>
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@osdl.org>,
       dipankar@in.ibm.com
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


RCU_TRACE is always defined.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>

---
diff -pur rc6-mm2/kernel/rcupreempt.c rc6-mm2-kw/kernel/rcupreempt.c
--- rc6-mm2/kernel/rcupreempt.c	2007-01-30 00:08:21.000000000 +0100
+++ rc6-mm2-kw/kernel/rcupreempt.c	2007-01-29 11:07:43.000000000 +0100
@@ -619,7 +619,7 @@ void synchronize_kernel(void)
 	synchronize_rcu();
 }
 
-#ifdef RCU_TRACE
+#ifdef CONFIG_RCU_TRACE
 int *rcupreempt_flipctr(int cpu)
 {
 	return &per_cpu(rcu_flipctr, cpu)[0];
