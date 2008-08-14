Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYHNCI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYHNCI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYHNCIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:08:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbYHNCIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:08:49 -0400
Date: Wed, 13 Aug 2008 19:03:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] [PATCH 1/2] x86: Microcode patch loader style
 corrections
Message-Id: <20080813190340.46927c18.akpm@linux-foundation.org>
In-Reply-To: <20080801104754.303635665@amd.com>
References: <20080801104644.788786464@amd.com>
	<20080801104754.303635665@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 12:46:45 +0200 Peter Oruba <peter.oruba@amd.com> wrote:

> Style corrections to main microcode module.

Needed a few fixups to apply against linux-next.

While we're there, let's spell "matching" correctly.

--- a/arch/x86/kernel/microcode.c~x86-microcode-patch-loader-style-corrections-fix
+++ a/arch/x86/kernel/microcode.c
@@ -264,7 +264,7 @@ static int microcode_sanity_check(void *
  * return 1 - found update
  * return < 0 - error
  */
-static int get_maching_microcode(void *mc, int cpu)
+static int get_matching_microcode(void *mc, int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	microcode_header_t *mc_header = mc;
@@ -405,7 +405,7 @@ static int do_microcode_update(void)
 			if (!uci->valid)
 				continue;
 			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-			error = get_maching_microcode(new_mc, cpu);
+			error = get_matching_microcode(new_mc, cpu);
 			if (error < 0)
 				goto out;
 			if (error == 1)
@@ -549,7 +549,7 @@ static int cpu_request_microcode(int cpu
 		error = microcode_sanity_check(mc);
 		if (error)
 			break;
-		error = get_maching_microcode(mc, cpu);
+		error = get_matching_microcode(mc, cpu);
 		if (error < 0)
 			break;
 		/*
_

