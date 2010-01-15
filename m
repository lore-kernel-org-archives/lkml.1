Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0AOD7w (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583Ab0AOD6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:58:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0AOD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=uYrdVis2xxEA:10 a=VwQbUJbxAAAA:8 a=u1RFgqVmoK6ePJGxMmEA:9 a=nht3YY3kth8g_rA9SowA:7 a=Pj1CeqeT84Uq-NoFw85Vq5c6IjoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035726.462940848@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/8][GIT PULL][v2.6.33] tracing: fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The patches fix one recordmcount.pl bug, and the rest fix
the filters for ftrace and the events.

Please pull the latest tip/tracing/urgent-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent-1


Jan Kiszka (1):
      tracing/x86: Derive arch from bits argument in recordmcount.pl

Li Zefan (7):
      ftrace: Fix MATCH_END_ONLY function filter
      tracing/filters: Fix MATCH_FRONT_ONLY filter matching
      tracing/filters: Fix MATCH_END_ONLY filter matching
      lib: Introduce strnstr()
      tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
      tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING
      tracing/filters: Add comment for match callbacks

----
 include/linux/string.h             |    5 ++++-
 kernel/trace/ftrace.c              |    6 +++---
 kernel/trace/trace_events_filter.c |   29 ++++++++++++++++++++---------
 lib/string.c                       |   27 ++++++++++++++++++++++++++-
 scripts/recordmcount.pl            |    2 +-
 5 files changed, 54 insertions(+), 15 deletions(-)
