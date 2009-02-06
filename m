Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZBFBON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZBFBON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZBFBNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:13:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbZBFBNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:13:53 -0500
Message-Id: <20090206011315.360405659@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Feb 2009 20:13:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/2] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      ring-buffer: add NMI protection for spinlocks
      ring-buffer: allow tracing_off to be used in core kernel code

----
 arch/x86/Kconfig            |    1 +
 arch/x86/kernel/ftrace.c    |    8 +++---
 include/linux/ftrace_irq.h  |   10 ++++++++-
 include/linux/ring_buffer.h |    9 ++++++++
 kernel/trace/Kconfig        |    8 +++++++
 kernel/trace/ring_buffer.c  |   48 +++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 77 insertions(+), 7 deletions(-)

-- 
