Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYKUV4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYKUV4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 16:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYKUV4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 16:56:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:23276 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbYKUV4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 16:56:19 -0500
Message-ID: <154e089b0811211356y79981d6cke1ea8bf3eddf7e50@mail.gmail.com>
Date: Fri, 21 Nov 2008 22:56:17 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Alok N Kataria" <akataria@vmware.com>, "Dan Hecht" <dhecht@vmware.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: hypervisor - fix sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

arch/x86/kernel/cpu/hypervisor.c:37:15: warning: symbol
'get_hypervisor_tsc_freq' was not declared. Should it be static?
arch/x86/kernel/cpu/hypervisor.c:53:16: warning: symbol
'init_hypervisor' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/kernel/cpu/hypervisor.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 35ae2b7..fb5b86a 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -23,6 +23,7 @@

 #include <asm/processor.h>
 #include <asm/vmware.h>
+#include <asm/hypervisor.h>

 static inline void __cpuinit
 detect_hypervisor_vendor(struct cpuinfo_x86 *c)
-- 
1.5.6.3
