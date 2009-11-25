Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZKYHPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZKYHPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZKYHPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:15:00 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:41062 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZKYHO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cilSWueyd19y21te7RwMf02IdiZZaZkTJ4GZ0ORBVzO6Gl3ufKkgOMznh4D0cg4iNF
         aAf00obUrCk9hzOb7wkMo1vxr1kMZNTFnQE6G56I+5cNj9Jh5UkBjQIFCf2WnYO/evFI
         m5WKEILV2Rf/O1Cnfr23wpGPrwWAfz6nJnLE8=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 0/2] tracing: minor fixes
Date: Wed, 25 Nov 2009 01:14:57 -0600
Message-Id: <1259133299-23594-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of minor fixes for things that were overlooked in previous patches.

Tom Zanussi (2):
  perf tools: Add 'signed' flag setting back into trace-event-parse.c
  trace/syscalls: Change ret param in struct syscall_trace_exit to long

 kernel/trace/trace.h                |    2 +-
 tools/perf/util/trace-event-parse.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

