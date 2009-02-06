Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZBFGFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZBFGFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZBFGF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:05:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60778 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZBFGF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:05:29 -0500
Message-Id: <20090206060328.181057235@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 01:03:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michael Neuling <mikey@neuling.org>
Subject: [PATCH 0/2] ftrace: updates for powerpc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul,

The first patch is a ftrace clean up to use the proper pr_debug macro.

The second patch is to fix a compile error when dynamic ftrace
is compiled in, but modules are not.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: ppc/ftrace


Steven Rostedt (2):
      ftrace, powerpc: replace debug macro with proper pr_deug
      powerpc, ftrace: fix compile error when modules not configured

----
 arch/powerpc/kernel/ftrace.c |   42 +++++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 17 deletions(-)
-- 
