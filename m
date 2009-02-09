Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZBIPVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZBIPVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZBIPVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:21:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbZBIPVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:21:03 -0500
Message-Id: <20090209151744.459736868@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 09 Feb 2009 10:17:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/2] git pull request for tip/tracing/urgent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Here's the changes by Lai. The bug scared me enough to investigate
it further, to see if we had other bug reports that this could
have fixed. But I found out that ring_buffer_read_page currently
does not have any users. The only user I have is for my splice work,
which has not been included yet.

I guess Lai is adding one. These are true bug fixes to code that
is in the kernel, even if that code is currently "dead code". But I think
they should still be included in 29, since this will reflect on ftrace
when we have developers starting to use it (such as Lai).

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/urgent/devel


Lai Jiangshan (2):
      ring_buffer: fix typing mistake
      ring_buffer: fix ring_buffer_read_page()

----
 kernel/trace/ring_buffer.c |   38 ++++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 16 deletions(-)


-- 
