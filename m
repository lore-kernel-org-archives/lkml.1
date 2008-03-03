Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbYCCRR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbYCCRR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbYCCRO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbYCCROZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:25 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 15/52] remove export for smp_call_function_mask.
Date: Mon,  3 Mar 2008 14:12:43 -0300
Message-Id: <1204564400-17636-16-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-15-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with this removal, exports for both i386 and x86_64,
regarding the "smp_call_function" series are now the same.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 275101a..a434f6c 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -400,7 +400,6 @@ int native_smp_call_function_mask(cpumask_t mask,
 	spin_unlock(&call_lock);
 	return ret;
 }
-EXPORT_SYMBOL(smp_call_function_mask);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
-- 
1.5.0.6

