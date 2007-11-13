Return-Path: <linux-kernel-owner+w=401wt.eu-S1761584AbXKMSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761584AbXKMSrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbXKMSrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:47:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53658 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761472AbXKMSrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:47:22 -0500
Message-Id: <20071113184627.667866257@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:46:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 00/11] Text Edit Lock
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 18:47:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is a repost of the Text Edit Lock. It is required by the immediate values.

It applies on top of 2.6.24-rc2-git3 in this order :

#Text Edit Lock
#for -mm
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

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
