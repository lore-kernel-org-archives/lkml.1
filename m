Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbZE0Xfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbZE0Xfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbZE0Xfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:35:30 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:35256 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZE0Xfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GcnrXhWi7l7fS0zO4XABk813QTMpugiNvWgQr6vTxq68OXc809ZWJ/lJIuvKYJvYjQ
         Bzw6sa90ouT1Leuu5kisQyhth6sMkQQA8UX4CGYwXTx7zDpW4S6EY4VS/HlJ3mm8Wn6N
         Ny797XjhkdUube1zFZ8Q4XApy6EXDISLEXagE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/2] tracing/core: another fixes
Date: Thu, 28 May 2009 01:35:25 +0200
Message-Id: <1243467327-13194-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two another fixes for ftrace, on top of tracing/core.

Thanks,
Frederic.

The following changes since commit c2adae0970ca1db8adb92fb56ae3bcabd916e8bd:
  Steven Rostedt (1):
        tracing: convert irq events to use __print_symbolic

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core

Heiko Carstens (1):
      trace: disable preemption before taking raw spinlocks

Zhaolei (1):
      ftrace: don't convert function's local variable name in macro

 include/trace/ftrace.h |   20 ++++++++++----------
 kernel/trace/trace.c   |    2 ++
 2 files changed, 12 insertions(+), 10 deletions(-)
