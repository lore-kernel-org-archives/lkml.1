Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbYKKUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbYKKUqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYKKUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:46:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55188 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYKKUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:46:23 -0500
Message-Id: <20081111204555.890501283@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 11 Nov 2008 15:45:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] ftrace: updates for linux-tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      ring-buffer: buffer record on/off switch
      ring-buffer: add reader lock
      ring-buffer: clean up warn ons

----
 include/linux/ring_buffer.h |    3 +
 kernel/trace/ftrace.c       |    8 +-
 kernel/trace/ring_buffer.c  |  351 ++++++++++++++++++++++++++++--------------
 3 files changed, 239 insertions(+), 123 deletions(-)
