Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZIKP3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZIKP3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZIKP3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbZIKP3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:29:35 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/3] tracing - adding common method for reading/parsing user input
Date: Fri, 11 Sep 2009 17:29:26 +0200
Message-Id: <1252682969-3366-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 3 different places for 4 user input files were using the same way
of reading and parsing user's input, I made one common routine to be
used. 

The mentioned files are:
	set_graph_function
	set_event
	set_ftrace_filter
	set_ftrace_notrace

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c       |  150 +++++++++++-------------------------------
 kernel/trace/trace.c        |  106 ++++++++++++++++++++++++++++++
 kernel/trace/trace.h        |   35 ++++++++++
 kernel/trace/trace_events.c |   60 ++++-------------
 4 files changed, 194 insertions(+), 157 deletions(-)
