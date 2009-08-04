Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbZHDPcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbZHDPcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZHDPcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:32:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851AbZHDPcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:32:11 -0400
Date: Tue, 4 Aug 2009 15:31:49 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090727143856.GA8905@sgi.com>
References: <20090727143856.GA8905@sgi.com>
Subject: [tip:x86/urgent] x86, UV: Fix UV apic mode
Message-ID: <tip-c5997fa8d7aca3c9876a6ff71bacf27c41095ce9@git.kernel.org>
Git-Commit-ID: c5997fa8d7aca3c9876a6ff71bacf27c41095ce9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:31:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5997fa8d7aca3c9876a6ff71bacf27c41095ce9
Gitweb:     http://git.kernel.org/tip/c5997fa8d7aca3c9876a6ff71bacf27c41095ce9
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 27 Jul 2009 09:38:56 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:19:14 +0200

x86, UV: Fix UV apic mode

Change SGI UV default apicid mode to "physical". This is
required to match settings in the UV hub chip.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090727143856.GA8905@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 445c210..832e908 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -261,7 +261,7 @@ struct apic apic_x2apic_uv_x = {
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
-	.irq_dest_mode			= 1, /* logical */
+	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= uv_target_cpus,
 	.disable_esr			= 0,
