Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYK0CyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYK0CyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYK0Cxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:53:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYK0Cxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:53:51 -0500
Message-Id: <20081127025227.026028481@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 21:52:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/1] ring-buffer fix for 2.6.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch needs to go into 2.6.28. It protects against
a recursion race that can happen when the scheduler is traced.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: devel


Lai Jiangshan (1):
      ring-buffer: prevent recursion

----
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
