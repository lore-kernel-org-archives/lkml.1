Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZBTQk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZBTQk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZBTQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:40:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZBTQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:40:48 -0500
Message-Id: <20090220163846.709775139@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 20 Feb 2009 11:38:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [git pull] updates for tip 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This is based off of your tip/x86/urgent branch.

Please pull the latest tip/x86/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/x86/ftrace


Steven Rostedt (5):
      ftrace: allow archs to preform pre and post process for code modification
      ftrace, x86: make kernel text writable only for conversions
      ftrace: immediately stop code modification if failure is detected
      ftrace: break out modify loop immediately on detection of error
      ftrace, x86: do not depend on system state for kernel text info

----
 arch/x86/include/asm/ftrace.h |   10 ++++++++++
 arch/x86/kernel/ftrace.c      |   16 ++++++++++++++++
 arch/x86/mm/init_32.c         |   37 ++++++++++++++++++++++++++++++++++---
 arch/x86/mm/init_64.c         |   39 ++++++++++++++++++++++++++++++++++-----
 include/linux/ftrace.h        |    3 +++
 kernel/trace/ftrace.c         |   34 +++++++++++++++++++++++++++++++++-
 6 files changed, 130 insertions(+), 9 deletions(-)
-- 
