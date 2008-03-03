Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbYCCRVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbYCCRVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbYCCRPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758994AbYCCRPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:12 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 28/52] remove cpu_llc_id from processor.h
Date: Mon,  3 Mar 2008 14:12:56 -0300
Message-Id: <1204564400-17636-29-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-28-git-send-email-gcosta@redhat.com>
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
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is already defined in smp.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 8bec23c..e49e5e6 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -355,9 +355,7 @@ union i387_union {
 	struct i387_soft_struct		soft;
 };
 
-#ifdef CONFIG_X86_32
-DECLARE_PER_CPU(u8, cpu_llc_id);
-#else
+#ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 #endif
 
-- 
1.5.0.6

