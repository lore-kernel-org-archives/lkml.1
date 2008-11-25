Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbYKYWfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbYKYWfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 17:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYKYWe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 17:34:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40396 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYKYWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:34:59 -0500
Message-Id: <20081125223421.795046329@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 25 Nov 2008 17:34:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] ftrace: new features
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The first patch adds a new feature to trace a single pid in the
function tracer.

The next two patches let the ftrace_return (graph now?) and the
function tracer run together.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      ftrace: add function tracing to single thread
      ftrace: use code patching for ftrace return tracer
      ftrace: let function tracing and function return run together

----
 Documentation/ftrace.txt   |   79 +++++++++++++
 arch/x86/kernel/entry_32.S |    5 +
 arch/x86/kernel/ftrace.c   |   46 ++++++++-
 include/linux/ftrace.h     |    5 +
 kernel/trace/ftrace.c      |  260 +++++++++++++++++++++++++++++++++-----------
 5 files changed, 331 insertions(+), 64 deletions(-)
