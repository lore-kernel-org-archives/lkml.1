Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbZJMHjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbZJMHjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbZJMHjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:39:41 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54880 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZJMHjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=K/XxrCWGgbtOdm5PfP9Tnwkv1m23+xQoOqlyYnZChRGB/VgXH0mzsEWCjLmiz378eZ
         nJ0wda+Hvp6O+BYVXYDo+PE/GHIHad1+TERnHETX4afyjT5LexKSJzsmG0zCkzTeuoHM
         JKZVcPgbRT8KkIfO62srKp/fOpe0ggXB6UI4g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Stefan Assmann <sassmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing/core updates
Date: Tue, 13 Oct 2009 09:38:57 +0200
Message-Id: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/core branch that can be found at

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks.

Frederic Weisbecker (2):
      tracing: Rename set_ftrace to set_bootup_ftrace
      tracing: Remove unused ftrace_trace_addr helper

Stefan Assmann (1):
      ftrace: add kernel command line graph function filtering

 Documentation/kernel-parameters.txt |    7 +++++++
 kernel/trace/ftrace.c               |   34 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c                |    4 ++--
 kernel/trace/trace.h                |    4 ----
 4 files changed, 43 insertions(+), 6 deletions(-)
