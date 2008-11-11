Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYKKEMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYKKEMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYKKEML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:12:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKKEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:12:11 -0500
Message-Id: <20081111041114.360885196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Nov 2008 23:11:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] ftrace: updates for linux-tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      ftrace: prevent ftrace_special from recursion
      ring-buffer: replace most bug ons with warn on and disable buffer

----
 kernel/trace/ring_buffer.c |   65 +++++++++++++++++++++++++++++++++-----------
 kernel/trace/trace.c       |    8 +++--
 2 files changed, 54 insertions(+), 19 deletions(-)
