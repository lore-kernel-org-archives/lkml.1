Return-Path: <linux-kernel-owner+w=401wt.eu-S935312AbYBBUxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935312AbYBBUxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764537AbYBBUww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:52:52 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:40297 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762482AbYBBUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:52:50 -0500
Message-Id: <20080202204930.620561121@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:49:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/2] Text Edit Lock
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:52:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is a resend of the Text Edit Lock patchset (only 2 patches). It consists of
a mutex that serializes code modification. Used by kprobes and the immediate
values.

Dependencies :

#Kprobes mutex cleanup
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
#Enhance DEBUG_RODATA support
x86-enhance-debug-rodata-support-alternatives.patch
x86-enhance-debug-rodata-support-for-hotplug-and-kprobes.patch

It applies on top of 2.6.24-git12 in this order:

#Text Edit Lock (depends on Enhance DEBUG_RODATA and kprobes mutex cleanup)
text-edit-lock-architecture-independent-code.patch
text-edit-lock-kprobes-architecture-independent-support.patch


Mathieu



-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
