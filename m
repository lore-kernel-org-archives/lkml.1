Return-Path: <linux-kernel-owner+w=401wt.eu-S934553AbYBBVM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbYBBVM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763286AbYBBVMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:12:20 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53839 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761658AbYBBVMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:12:19 -0500
Message-Id: <20080202210828.840735763@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 16:08:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/7] Immediate Values
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 21:12:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the updated immediate values for 2.6.24-git12.

Dependencies :

# instrumentation menu removal #merged in kbuild.git
fix-arm-to-play-nicely-with-generic-instrumentation-menu.patch
create-arch-kconfig.patch
add-have-oprofile.patch
add-have-kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
#
#Kprobes mutex cleanup
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
#Enhance DEBUG_RODATA support
x86-enhance-debug-rodata-support-alternatives.patch
x86-enhance-debug-rodata-support-for-hotplug-and-kprobes.patch
#Text Edit Lock (depends on Enhance DEBUG_RODATA and kprobes mutex cleanup)
text-edit-lock-architecture-independent-code.patch
text-edit-lock-kprobes-architecture-independent-support.patch

The patchset applies in the following order :

#Immediate Values
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-menu-in-embedded.patch
immediate-values-x86-optimization.patch
add-text-poke-and-sync-core-to-powerpc.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
#
scheduler-profiling-use-immediate-values.patch
#

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
