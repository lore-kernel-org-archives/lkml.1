Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbZGRHRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbZGRHRJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932466AbZGRHRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:17:07 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:53553 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbZGRHRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BpdO88aNFUqhhF3zLryxQN/cbjZF2DauM8aeJ5AjNMCBg3NCNC+E03LvlgWJR77sDe
         TOjXBB0p5IAO9USc1+BPbyj+1xFJC2FdbbyoOKAo3QOHiezgq6OcHlGmq1tpuyJ01TIy
         aSnKoTN8oBiq3jSH1h/iC/9FK/2L0orK7lp7o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [GIT PULL] tracing updates for 2.6.32
Date: Sat, 18 Jul 2009 03:16:57 -0400
Message-Id: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas,

Here are some fixes and enhancements for the 2.6.32 tracing tree.

Impacts:

- A spurious warning in the lockless ring buffer had been shutdown
- Simplifications of various ftrace code areas resulting in more deletions than
  additions.

These changes have been based against tip:tracing/core

Thanks,

Frederic.


The following changes since commit e202687927c132b1e1ff36b526b5e78ac33de840:
  Ingo Molnar (1):
        Merge branch 'tip/tracing/ring-buffer-3' of git://git.kernel.org/.../rostedt/linux-2.6-trace into tracing/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core

Lai Jiangshan (1):
      ring_buffer: Fix warning while ignoring cmpxchg return value

Xiao Guangrong (3):
      tracing/function: Simplify __ftrace_replace_code()
      tracing/trace_stack: Cleanup for trace_lookup_stack()
      tracing/function: Cleanup for function tracer

 kernel/trace/ftrace.c          |   89 +++++++++------------------------------
 kernel/trace/ring_buffer.c     |    9 +++-
 kernel/trace/trace_functions.c |    4 +-
 kernel/trace/trace_stack.c     |    9 +----
 4 files changed, 30 insertions(+), 81 deletions(-)
