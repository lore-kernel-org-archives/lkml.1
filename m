Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZIQE2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZIQE2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 00:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZIQE2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 00:28:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47080 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZIQE22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 00:28:28 -0400
Message-Id: <20090917042731.630008734@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Sep 2009 00:27:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing: small fixes for v2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core5 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core5


Christian Borntraeger (1):
      oprofile: fix oprofile regression: select RING_BUFFER_ALLOW_SWAP

Steven Rostedt (2):
      vsprintf: add %ps that is the same as %pS but is like %pf
      tracing: switch function prints from %pf to %ps

----
 arch/Kconfig                         |    1 +
 kernel/trace/ftrace.c                |    6 +++---
 kernel/trace/trace_functions.c       |    2 +-
 kernel/trace/trace_functions_graph.c |    6 +++---
 lib/vsprintf.c                       |    6 ++++--
 5 files changed, 12 insertions(+), 9 deletions(-)
