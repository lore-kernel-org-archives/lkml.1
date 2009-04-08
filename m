Return-Path: <linux-kernel-owner+w=401wt.eu-S1764701AbZDHNBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764701AbZDHNBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbZDHNBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:01:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:41563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbZDHNBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:01:11 -0400
Date: Wed, 8 Apr 2009 13:00:32 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D6A692.6040400@kernel.org>
References: <49D6A692.6040400@kernel.org>
Subject: [tip:x86/apic] x86: make wakeup_secondary_cpu_via_init static
Message-ID: <tip-cdc1cb0d4445f39561a65204d26f89365f917550@git.kernel.org>
Git-Commit-ID: cdc1cb0d4445f39561a65204d26f89365f917550
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 13:00:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdc1cb0d4445f39561a65204d26f89365f917550
Gitweb:     http://git.kernel.org/tip/cdc1cb0d4445f39561a65204d26f89365f917550
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 3 Apr 2009 17:15:14 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 14:50:28 +0200

x86: make wakeup_secondary_cpu_via_init static

Impact: cleanup

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49D6A692.6040400@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..bddf2cc 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -538,7 +538,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
-int __devinit
+static int __devinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
