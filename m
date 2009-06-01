Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZFARRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZFARRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbZFARRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:17:21 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47405 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbZFARRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U4rG3x6pQG4uROOkJJVgYzPPKTKMHY8mWEYQJbLC2vv2IJC1Sj+gLUY8pvgXW3dGb7
         NwfSR/OnyT5+GzEm3AvckxBVyGHr5yB9WHy8wmULKDmhXXWKEhhS1QhY/mMIYJif8xRm
         95qyCmAjRakU/i6X4269eO66wvpxF7eQSmgCU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       Anton Blanchard <anton@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5] tracing/workqueue updates
Date: Mon,  1 Jun 2009 19:17:12 +0200
Message-Id: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following patches are fixes and cleanup for the workqueue tracer.

One of them makes the worklet search patch faster.
Some of them fix and sanitize the histogram output and the others clean and
standardize the code.

Thanks.

The following changes since commit c5f0530c4bb2ec77a805cfcf23db09b3e5ab09d4:
  Ingo Molnar (1):
        Merge branch 'tracing/core' into tracing/workqueues

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/workqueue

Anton Blanchard (2):
      tracing/events: use %pf in workqueue trace events
      tracing/events: rename worklet_execute to worklet_entry and worklet_complete to worklet_exit

Zhaolei (3):
      tracing/workqueue: get rid of searching last executed worklet in probe_worklet_complete()
      tracing/workqueue: fix list header and function name format
      tracing/workqueue: cleanup for trace_workqueue.c

 Documentation/trace/workqueue.txt |   12 ++--
 include/trace/events/workqueue.h  |    8 +-
 kernel/trace/trace_workqueue.c    |  124 +++++++++++++++++-------------------
 3 files changed, 69 insertions(+), 75 deletions(-)
