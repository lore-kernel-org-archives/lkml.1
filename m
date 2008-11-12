Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYKLF4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYKLF4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKLF4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:56:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYKLF4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:56:03 -0500
Message-Id: <20081112055454.798779203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:54:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] boot tracer updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Frederic Weisbecker (2):
      tracing/fastboot: Move boot tracer structs and funcs into their own header.
      tracing/fastboot: Use the ring-buffer timestamp for initcall entries

----
 include/linux/ftrace.h    |   41 ---------------
 include/trace/boot.h      |   56 ++++++++++++++++++++
 init/main.c               |   33 +++++++------
 kernel/trace/trace.h      |   16 ++++--
 kernel/trace/trace_boot.c |  123 ++++++++++++++++++++++++++++++++++-----------
 5 files changed, 179 insertions(+), 90 deletions(-)
