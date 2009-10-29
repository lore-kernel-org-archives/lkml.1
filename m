Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbZJ2WdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbZJ2WdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZJ2WdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:33:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZJ2WdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:14 -0400
Message-Id: <20091029223254.504427063@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:32:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8] tracing: fixes and cleanups for recordmcount.pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Li Hong (8):
      tracing: Amend documentation in recordmcount.pl to reflect implementation
      tracing: Correct the check for number of arguments in recordmcount.pl
      tracing: Check absolute path of input file in recordmcount.pl
      tracing: Fix objcopy revision check in recordmcount.pl
      tracing: Move mcount section search to front of loop in recordmcount.pl
      tracing: Add regex for weak functions in recordmcount.pl
      tracing: Move conditional into update_funcs() in recordmcount.pl
      tracing: Exit with error if a weak function is used in recordmcount.pl

----
 scripts/recordmcount.pl |  210 +++++++++++++++++++++++++----------------------
 1 files changed, 111 insertions(+), 99 deletions(-)
