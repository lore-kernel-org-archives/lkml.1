Return-Path: <linux-kernel-owner+w=401wt.eu-S936018AbXHLPHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936018AbXHLPHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbXHLPHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:07:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47414 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935294AbXHLPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:07:10 -0400
Message-Id: <20070812150402.148764478@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:04:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/9] Text Edit Lock
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:06:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the the text edit lock.

It consists in an architecture independent mutex that protects live kernel text
modification and architecture specific RX/RWX remapping functions (for i386 and
x86_64) to support the DEBUG_RODATA config option.

It applies on 2.6.23-rc2-mm2.

Series files:

kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
text-edit-lock-architecture-independent-code.patch
text-edit-lock-i386.patch
text-edit-lock-x86_64.patch
text-edit-lock-kprobes-architecture-independent.patch
text-edit-lock-kprobes-i386.patch
text-edit-lock-kprobes-x86_64.patch


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
