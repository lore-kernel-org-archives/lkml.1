Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYKLFDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYKLFDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYKLFCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:02:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYKLFCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:02:21 -0500
Message-Id: <20081112050125.654925304@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:01:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] ring-buffer updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      ring-buffer: fix deadlock from reader_lock in read_start
      ring-buffer: no preempt for sched_clock

----
 kernel/trace/ring_buffer.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)
