Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYKMFLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYKMFLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYKMFLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:11:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33524 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYKMFLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:11:08 -0500
Message-Id: <20081113050933.625130887@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Nov 2008 00:09:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] ftrace patches for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Note: first patch is the same as the one for 2.6.28. I just ported it for
tip but you can ignore it if you already pulled that one in.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      ftrace: do not update max buffer with no users
      ftrace: show buffer size in kilobytes

----
 Documentation/ftrace.txt |   22 ++-----
 kernel/trace/trace.c     |  176 ++++++++++++++++++++++++----------------------
 2 files changed, 97 insertions(+), 101 deletions(-)
