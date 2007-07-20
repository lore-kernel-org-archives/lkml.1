Return-Path: <linux-kernel-owner+w=401wt.eu-S934282AbXGTSkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282AbXGTSkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbXGTSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:40:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46636 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbXGTSka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:40:30 -0400
Subject: [PATCH] x86_64: include asm/bugs.h in bugs.c for check_bugs
	prototype
From: Josh Triplett <josh@kernel.org>
Reply-To: josh@kernel.org, josht@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:40:46 -0700
Message-Id: <1184956846.2630.9.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

C files should include the header files that prototype their functions.

Eliminates a sparse warning:
warning: symbol 'check_bugs' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 arch/x86_64/kernel/bugs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/kernel/bugs.c b/arch/x86_64/kernel/bugs.c
index c3c6b91..4e5e9d3 100644
--- a/arch/x86_64/kernel/bugs.c
+++ b/arch/x86_64/kernel/bugs.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <asm/alternative.h>
+#include <asm/bugs.h>
 #include <asm/processor.h>
 #include <asm/mtrr.h>
 
-- 
1.5.2.1



