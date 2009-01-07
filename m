Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZAGMmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZAGMmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZAGMma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:42:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:60962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZAGMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:42:28 -0500
Subject: [PATCH -tip 1/7] x86: smp.h remove obsolete function declaration
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 18:10:13 +0530
Message-Id: <1231332013.18558.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/smp.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19953df..643a3a0 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -39,7 +39,6 @@ extern cpumask_t cpu_sibling_setup_map;
 
 #endif /* CONFIG_X86_32 */
 
-extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
 
 extern int __cpuinit get_local_pda(int cpu);
-- 
1.5.6.6



