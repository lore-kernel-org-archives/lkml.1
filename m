Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYLCXmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYLCXmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYLCXmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:42:46 -0500
Received: from ozlabs.org ([203.10.76.45]:48412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYLCXmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:42:45 -0500
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 4 Dec 2008 10:12:41 +1030
Subject: [PATCH] parisc: remove gratuitous cpu_online_map declaration.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812041012.41496.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is defined in linux/cpumask.h (included in this file already),
and this will break when the definition changes (in a following patch).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/parisc/include/asm/smp.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/parisc/include/asm/smp.h b/arch/parisc/include/asm/smp.h
--- a/arch/parisc/include/asm/smp.h
+++ b/arch/parisc/include/asm/smp.h
@@ -15,8 +15,6 @@
 #include <linux/threads.h>	/* for NR_CPUS */
 #include <linux/cpumask.h>
 typedef unsigned long address_t;
-
-extern cpumask_t cpu_online_map;
 
 
 /*


