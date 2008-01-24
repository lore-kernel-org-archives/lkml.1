Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYAXUf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYAXUf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbYAXUeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:34:11 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58192 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbYAXUeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:34:08 -0500
Message-Id: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 00/26] Instrumentation Support Enhancement (2.6.24-rc8-mm1)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the latest instrumentation support enhancements. These include :

* Markers support for proprierary modules
  (this is an updated version of the one I sent earlier, nothing big, just a
  small fuzz checked and refreshed)
* Instrumentation menu removal
* Text Edit Lock
* Immediate Values
* Linux Kernel Markers use Immediate Values

This patchset is fully bissectable, so if, for instance, someone is not happy
with the last functionnality (Linux Kernel Markers use Immediate Values), it can
be left out and the rest is completely usable as is.

Which apply on top of 2.6.24-rc8-mm1 in this order :

markers-support-for-proprietary-modules.patch
#
#Instrumentation menu removal
fix-arm-to-play-nicely-with-generic-instrumentation-menu.patch
move-kconfig-instrumentation-to-arch.patch
#
#Text Edit Lock
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
declare-array.patch
text-edit-lock-architecture-independent-code.patch
text-edit-lock-alternative-i386-and-x86_64.patch
text-edit-lock-kprobes-architecture-independent.patch
text-edit-lock-kprobes-x86.patch
text-edit-lock-i386-standardize-debug-rodata.patch
text-edit-lock-x86_64-standardize-debug-rodata.patch
#
#Immediate Values
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-embedded.patch
immediate-values-x86-optimization.patch
add-text-poke-to-powerpc.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
#
profiling-use-immediate-values.patch
#
#Linux Kernel Markers use Immediate Values
immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
add-discard-section-to-x86.patch
immediate-values-x86-optimization-nmi-mce-support.patch
immediate-values-powerpc-optimization-nmi-mce-support.patch
immediate-values-use-arch-nmi-mce-support.patch
linux-kernel-markers-immediate-values.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
