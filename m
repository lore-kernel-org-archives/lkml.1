Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbYKLFPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbYKLFPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYKLFPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:15:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYKLFPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:15:19 -0500
Message-Id: <20081112051438.843792214@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:14:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 0/2] unlikely profiler and tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      trace: profile likely and unlikely annotations
      ftrace: unlikely annotation tracer

----
 arch/x86/kernel/vsyscall_64.c     |    8 +
 include/asm-generic/vmlinux.lds.h |   14 ++-
 include/linux/compiler.h          |   61 ++++++++-
 kernel/trace/Kconfig              |   38 +++++
 kernel/trace/Makefile             |    7 +
 kernel/trace/trace.c              |   29 ++++
 kernel/trace/trace.h              |   39 +++++
 kernel/trace/trace_unlikely.c     |  278 +++++++++++++++++++++++++++++++++++++
 8 files changed, 471 insertions(+), 3 deletions(-)
