Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbXKMTA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbXKMTA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbXKMTAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:00:45 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38191 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbXKMTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:00:44 -0500
Message-Id: <20071113185800.436425570@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:58:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] Immediate Values (now with merged x86 support)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:00:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the latest version of the Immediate Values. It supports x86 as a single
architecture. I also removed the *_early API which could have been confusing to
developers : choosing the right algorithm is now done internally by keeping
track of where we are in the kernel boot process.

The patchset depends on :
"Instrumentation menu removal"
and
"Text Edit Lock".

It is based on 2.6.24-rc2-git3 and applies in this order :

#Immediate Values
#for -mm
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-embedded.patch
immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
add-asm-compat-to-x86.patch
immediate-values-x86-optimization.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
#
profiling-use-immediate-values.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
