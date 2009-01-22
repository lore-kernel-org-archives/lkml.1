Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZAVUVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZAVUVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZAVUVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:21:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZAVUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:21:11 -0500
Message-Id: <20090122202030.210768976@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 15:20:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      trace: remove internal irqsoff disabling for trace output
      trace: fix logic to start/stop counting

----
 kernel/trace/trace.c         |   13 ++++++-------
 kernel/trace/trace_irqsoff.c |   34 ++--------------------------------
 2 files changed, 8 insertions(+), 39 deletions(-)
-- 
