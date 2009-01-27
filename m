Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZA0FaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZA0FaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZA0F3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:29:49 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:46120 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZA0F3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=shYgWnsEeELsYicjZyOydZIEuRvwMmyLD/YvKqO0t1Q00qb44UmkUth8IuAvk7K4/h
         iTIeMl1TIM/SIGrvD9WUqhbrXjz6QVKf4M2iX8n99hUObFQQ90dthXAiZSazu8y++RyR
         m8MUIDisoMiWOsBeOm8fVzshqDS23shMI3WXk=
Message-ID: <497E9BCA.4050808@gmail.com>
Date: Tue, 27 Jan 2009 14:29:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 #tj-percpu] x86: clean up indentation in setup_per_cpu_areas()
References: <20090126103243.GA31307@elte.hu>	 <1232977445-11815-1-git-send-email-brgerst@gmail.com>	 <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>	 <497E8778.9060503@gmail.com> <1233032609.3248.78.camel@localhost.localdomain> <497E9B9D.4010102@gmail.com>
In-Reply-To: <497E9B9D.4010102@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cosmetic cleanup

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index c7458ea..0d1e7ac 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -96,22 +96,25 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(cpu_number, cpu) = cpu;
 		setup_percpu_segment(cpu);
 		/*
-		 * Copy data used in early init routines from the initial arrays to the
-		 * per cpu data areas.  These arrays then become expendable and the
-		 * *_early_ptr's are zeroed indicating that the static arrays are gone.
+		 * Copy data used in early init routines from the
+		 * initial arrays to the per cpu data areas.  These
+		 * arrays then become expendable and the *_early_ptr's
+		 * are zeroed indicating that the static arrays are
+		 * gone.
 		 */
 #ifdef CONFIG_X86_LOCAL_APIC
 		per_cpu(x86_cpu_to_apicid, cpu) =
-				early_per_cpu_map(x86_cpu_to_apicid, cpu);
+			early_per_cpu_map(x86_cpu_to_apicid, cpu);
 		per_cpu(x86_bios_cpu_apicid, cpu) =
-				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
+			early_per_cpu_map(x86_bios_cpu_apicid, cpu);
 #endif
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
-			per_cpu(irq_stack_union.irq_stack, cpu) + IRQ_STACK_SIZE - 64;
+			per_cpu(irq_stack_union.irq_stack, cpu) +
+			IRQ_STACK_SIZE - 64;
 #ifdef CONFIG_NUMA
 		per_cpu(x86_cpu_to_node_map, cpu) =
-				early_per_cpu_map(x86_cpu_to_node_map, cpu);
+			early_per_cpu_map(x86_cpu_to_node_map, cpu);
 #endif
 #endif
 		/*
-- 
1.6.0.2

