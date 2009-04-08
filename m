Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbZDHQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbZDHQKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbZDHQKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:10:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbZDHQKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:10:14 -0400
Date: Wed, 8 Apr 2009 16:09:33 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DCBBF1.8080903@kernel.org>
References: <49DCBBF1.8080903@kernel.org>
Subject: [tip:x86/urgent] x86: make 64 bit to use default_inquire_remote_apic
Message-ID: <tip-08d63b10db943d4e1ff5ae3abc33467f037477f3@git.kernel.org>
Git-Commit-ID: 08d63b10db943d4e1ff5ae3abc33467f037477f3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:09:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08d63b10db943d4e1ff5ae3abc33467f037477f3
Gitweb:     http://git.kernel.org/tip/08d63b10db943d4e1ff5ae3abc33467f037477f3
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 8 Apr 2009 08:00:01 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 17:36:12 +0200

x86: make 64 bit to use default_inquire_remote_apic

Impact: restore old behavior

for flat and phys_flat

Signed-off-by: Yinhai Lu <yinghai@kernel.org.
LKML-Reference: <49DCBBF1.8080903@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic_flat_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 0014714..306e5e8 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -212,7 +212,7 @@ struct apic apic_flat =  {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.inquire_remote_apic		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
@@ -362,7 +362,7 @@ struct apic apic_physflat =  {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.inquire_remote_apic		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
