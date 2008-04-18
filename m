Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYDRG6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYDRG6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbYDRG5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:57:31 -0400
Received: from ozlabs.org ([203.10.76.45]:38774 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267AbYDRG5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:57:30 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 18 Apr 2008 16:56:18 +1000
Subject: [PATCH 3/3] Use __weak macro for smp_setup_processor_id
Message-Id: <20080418065728.31AF4DE255@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the __weak macro instead of the longer __attribute__ ((weak)) form

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
--

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-work.orig/init/main.c	2008-04-18 16:44:32.000000000 +1000
+++ linux-work/init/main.c	2008-04-18 16:44:37.000000000 +1000
@@ -500,7 +500,7 @@ static void __init boot_cpu_init(void)
 	cpu_set(cpu, cpu_possible_map);
 }
 
-void __init __attribute__((weak)) smp_setup_processor_id(void)
+void __init __weak smp_setup_processor_id(void)
 {
 }
 
