Return-Path: <linux-kernel-owner+w=401wt.eu-S1764024AbZAIA3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764024AbZAIA3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZAIA2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:28:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51364 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbZAIA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:28:42 -0500
Message-Id: <20090109002747.240318148@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 08 Jan 2009 19:27:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 0/3] ftrace: updates for 2.6.29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Pekka Paalanen (3):
      doc: mmiotrace.txt, buffer size control change
      trace: mmiotrace to the tracer menu in Kconfig
      mmiotrace: count events lost due to not recording

----
 Documentation/tracers/mmiotrace.txt |    6 ++----
 arch/x86/Kconfig.debug              |   24 ++----------------------
 kernel/trace/Kconfig                |   23 +++++++++++++++++++++++
 kernel/trace/trace_mmiotrace.c      |   14 ++++++++++----
 4 files changed, 37 insertions(+), 30 deletions(-)

-- 
