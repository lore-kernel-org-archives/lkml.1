Return-Path: <linux-kernel-owner+w=401wt.eu-S933155AbZDAOVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbZDAOVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932754AbZDAOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:20:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbZDAOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:20:40 -0400
Message-Id: <20090401141949.714854885@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Apr 2009 10:19:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] updates for tip core-v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I sent these patches before, but this time I rebased to your core-v2
branch.

Please pull the latest tip/tracing/core-v2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-v2


Steven Rostedt (2):
      function-graph: allow unregistering twice
      ring-buffer: do not remove reader page from list on ring buffer free

----
 kernel/trace/ftrace.c      |    4 ++++
 kernel/trace/ring_buffer.c |    1 -
 2 files changed, 4 insertions(+), 1 deletions(-)
-- 
