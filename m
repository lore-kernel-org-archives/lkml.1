Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZIDNbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZIDNbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZIDNbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:31:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbZIDNbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:31:21 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tracing - adding common method for reading/parsing user input
Date: Fri,  4 Sep 2009 15:31:10 +0200
Message-Id: <1252071073-27134-1-git-send-email-jolsa@redhat.com>
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
 kernel/trace/ftrace.c       |  152 ++++++++++++-------------------------------
 kernel/trace/trace.c        |   83 +++++++++++++++++++++++
 kernel/trace/trace.h        |   48 ++++++++++++++
 kernel/trace/trace_events.c |   58 ++++-------------
 4 files changed, 186 insertions(+), 155 deletions(-)
