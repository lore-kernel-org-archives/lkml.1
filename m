Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYLWQfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYLWQfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYLWQfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:35:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYLWQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:35:00 -0500
Message-Id: <20081223163223.625941559@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 23 Dec 2008 11:32:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] ring-buffer: updates for 2.6.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

These two patches should go to 2.6.28. They are fixes to the ring buffer
for bugs that will make the ring buffer stop reading, and/or produce
a false positive.

If these are too late for 2.6.28, then we probably should get them at least
to the stable branch and queued for 2.6.28.1.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: devel


Steven Rostedt (2):
      ring-buffer: fix dangling commit race
      ring-buffer: prevent false positive warning

----
 kernel/trace/ring_buffer.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)
