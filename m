Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZH0Dew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZH0Dew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZH0Dev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:34:51 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50461 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZH0Deu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KyBAzc49Q3fx7LgfXvj2mQRbXJFQu+2a4ZGoOwe6tYKBDo5T75eXf49HzkY9dEskDS
         cOunYAgY/A40SEW74Ce3AcAhlEYx5YZwjLCjp5NDheu4zlzVAkn6Etyuy1OzVARXBn/I
         iZifvy46mlEM2TeRXipCDYCi6/EtBSfYzNXR4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [GIT PULL v2] tracing/kprobes: v1 + two fixes
Date: Thu, 27 Aug 2009 05:34:45 +0200
Message-Id: <1251344087-28719-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This v2 can be either pulled after tracing/kprobes (the v1) or can be pulled
alone, it is based on the previous one and addresses reviews from Li Zefan.

Thanks,
Frederic.

The following changes since commit 24851d2447830e6cba4c4b641cb73e713f312373:
  Frederic Weisbecker (1):
        tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	tracing/kprobes-2

Frederic Weisbecker (2):
      tracing: Restore the const qualifier for field names and types definition
      tracing: Remove unneeded pointer casts

 include/linux/ftrace_event.h  |    6 +++---
 kernel/trace/trace_events.c   |    4 ++--
 kernel/trace/trace_syscalls.c |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)
