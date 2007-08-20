Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXHTUZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXHTUZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763115AbXHTUWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:22:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54439 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763090AbXHTUWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:22:15 -0400
Message-Id: <20070820201902.597091353@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:19:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 00/11] Text Edit Lock / text poke
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:21:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This new version includes a rewrite of the i386 and x86_64 text edit lock using
text poke. I clear and set the WP cr0 bit instead of changing the page
attributes when patching RO code.

It applies to 2.6.23-rc2-mm2 in this order:

kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
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
