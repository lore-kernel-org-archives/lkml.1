Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZDEOsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZDEOsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 10:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZDEOrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 10:47:32 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:33817 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755103AbZDEOrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 10:47:31 -0400
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Apr 2009 10:47:30 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=elastic.org;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
	b=tKc2ftO+3jcfR0Bwu0e64kUJoOFdcpGerhmZgrYC+y9j38HJC0gMRQqoaT0RRLJJhuze8nGpxG+rKYEAiyfxN9+SPlMJtlvXC5589UVaMdfh4GOSf9ctUVSQ1eXxcVb/;
From: "Frank Ch. Eigler" <fche@elastic.org>
To: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Cc: systemtap@sources.redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       mingo@elte.hu, "Frank Ch. Eigler" <fche@elastic.org>
Subject: [PATCH tip 0/2] utrace-ftrace engine v3
Date: Sun,  5 Apr 2009 10:17:52 -0400
Message-Id: <1238941074-27424-1-git-send-email-fche@elastic.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of the utrace-ftrace engine represents bringing v2 (as
posted along with utrace two weeks ago) up to parity with the
tip/tracing/syscalls one in terms of using the system call
pretty-printing tables.  This patch applies to the
tip/tracing/syscalls tree, except that it assumes that utrace patches
are also applied beforehand.

Next up could be adding an option to use the filterable TRACE_EVENT
tracepoint engine instead of (or in addition to?)  the hand-written
trace record management & formatting.

Next up could also be removal of the syscall-tracing prototype, if
people are so inclined.


Frank Ch. Eigler (2):
  make arch_init_ftrace_syscalls multiply callable
  utrace-based ftrace "process" engine, v3

 arch/x86/kernel/ftrace.c     |    3 +
 include/linux/processtrace.h |   51 ++++
 kernel/trace/Kconfig         |    8 +
 kernel/trace/Makefile        |    1 +
 kernel/trace/trace.h         |    9 +
 kernel/trace/trace_process.c |  642 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 714 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/processtrace.h
 create mode 100644 kernel/trace/trace_process.c

