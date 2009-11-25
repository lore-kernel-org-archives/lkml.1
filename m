Return-Path: <linux-kernel-owner+w=401wt.eu-S935138AbZKYV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138AbZKYV4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759341AbZKYVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:55:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33321 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759004AbZKYVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:55:57 -0500
Message-Id: <20091125215529.492517040@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 25 Nov 2009 16:55:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] tracing/ring-buffer-benchmark: mods and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Lai Jiangshan (1):
      tracing: Separate raw syscall from syscall tracer

Steven Rostedt (1):
      ring-buffer-benchmark: Add parameters to set produce/consumer priorities

----
 include/trace/events/syscalls.h      |    3 +-
 kernel/trace/ring_buffer_benchmark.c |   58 ++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 3 deletions(-)
