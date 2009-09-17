Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZIQT5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZIQT5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZIQT5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:57:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35919 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZIQT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:57:43 -0400
Message-Id: <20090917195508.189551309@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Sep 2009 15:55:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] tracing: more updates for v2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is a rebase of the core5 I pushed earlier. Changes are:

- rebased against your pull of Linus's latest
- Added Ben's Acked-by.
- Three new patches:
   * oprofile: fix oprofile regression: select RING_BUFFER_ALLOW_SWAP
   * softirq: add BLOCK_IOPOLL to softirq_to_name
   * vsnprintf: remove duplicate comment of vsnprintf


Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Christian Borntraeger (1):
      oprofile: fix oprofile regression: select RING_BUFFER_ALLOW_SWAP

Li Zefan (1):
      softirq: add BLOCK_IOPOLL to softirq_to_name

Steven Rostedt (3):
      vsprintf: add %ps that is the same as %pS but is like %pf
      tracing: switch function prints from %pf to %ps
      vsnprintf: remove duplicate comment of vsnprintf

----
 arch/Kconfig                         |    1 +
 include/trace/events/irq.h           |   21 +++++++++++----------
 kernel/softirq.c                     |    2 +-
 kernel/trace/ftrace.c                |    6 +++---
 kernel/trace/trace_functions.c       |    2 +-
 kernel/trace/trace_functions_graph.c |    6 +++---
 lib/vsprintf.c                       |   16 ++++++++--------
 7 files changed, 28 insertions(+), 26 deletions(-)
