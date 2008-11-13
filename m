Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYKMEiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYKMEiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 23:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYKMEhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 23:37:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYKMEhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 23:37:54 -0500
Message-Id: <20081113043449.751885305@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 23:34:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 0/1] ftrace patches for 2.6.28 (update)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  As Andrew pointed out, the previous version had a lot of ugly
  #ifdefs. This patch removes them and just does the check at
  the resize. It also hides the max latency recording functions
  behind the config option.

  The git tree now has this version instead.
]

Ingo,

The following patches are against mainline, and need to go in 2.6.28:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: devel


Steven Rostedt (1):
      ftrace: do not update max buffer with no users

----
 kernel/trace/trace.c |  171 ++++++++++++++++++++++++++------------------------
 1 files changed, 88 insertions(+), 83 deletions(-)
