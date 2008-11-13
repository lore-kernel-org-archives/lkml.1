Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYKMBc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYKMBc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYKMBcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:32:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYKMBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:32:49 -0500
Message-Id: <20081113013041.086583690@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 20:30:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/1] ftrace updates for 2.6.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are against mainline, and need to go in 2.6.28:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: devel


Steven Rostedt (1):
      ftrace: do not update max buffer with no users

----
 kernel/trace/trace.c |  157 +++++++++++++++++++++++++++----------------------
 1 files changed, 86 insertions(+), 71 deletions(-)

-- 
