Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbXLUCDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbXLUCDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbXLUB67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:58:59 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53291 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760891AbXLUB6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:58:55 -0500
Message-Id: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:54:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 00/24] Markers use immediate values, for 2.6.24-rc5-mm1
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the patches that would be interesting to queue for 2.6.25. As you
asked, the patchset applies to 2.6.24-rc5-mm1.

It includes those logical changes and applies in the following order.

Thanks,

Mathieu

#Text Edit Lock
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
declare-array.patch
text-edit-lock-architecture-independent-code.patch
text-edit-lock-alternative-i386-and-x86_64.patch
text-edit-lock-kprobes-architecture-independent.patch
text-edit-lock-kprobes-i386.patch
text-edit-lock-kprobes-x86_64.patch
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
#Markers use immediate values
immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
add-discard-section-to-x86.patch
immediate-values-x86-optimization-nmi-mce-support.patch
immediate-values-powerpc-optimization-nmi-mce-support.patch
immediate-values-use-arch-nmi-mce-support.patch
linux-kernel-markers-immediate-values.patch

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
