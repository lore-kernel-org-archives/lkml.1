Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZFCOQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZFCOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZFCOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:16:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47260 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbZFCOQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:16:49 -0400
Message-Id: <20090603141605.001049251@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 10:16:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 0/3] [GIT PULL] (second try) ring-buffer: fixes for discard
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-3


Steven Rostedt (2):
      ring-buffer: try to discard unneeded timestamps
      ring-buffer: discard timestamps that are at the start of the buffer

Tim Bird (1):
      ring-buffer: fix bug in ring_buffer_discard_commit

----
 kernel/trace/ring_buffer.c |  104 ++++++++++++++++++++++++++------------------
 1 files changed, 62 insertions(+), 42 deletions(-)
-- 
