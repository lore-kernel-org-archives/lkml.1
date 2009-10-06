Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbZJFGBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbZJFGBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZJFGBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:01:32 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:45536 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbZJFGBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lcFy2kfLArlg3bgp947tZPyk3RlLt4fvUC2B5hHBF4w5GLvOLutg/Dfg3FOlYginCh
         Y2o4+Q3QkcQ7PdRTKDBwrFQUhUtU851Zaux1j3zZlliWssUb8aRzziUYbDqD2btNDKdp
         hdDv479SGF3RTSle1MTucuWh/F37tj674tYyA=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Subject: [PATCH 0/3] a few tracing bugfixes
Date: Tue,  6 Oct 2009 01:00:46 -0500
Message-Id: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fixes for a few things I noticed recently.

Tom Zanussi (3):
  perf trace: Remove unused code in builtin-trace.c
  perf trace: Update eval_flag() flags array to match interrupt.h
  tracing/syscalls: Use long for syscall ret format and field
    definitions

 kernel/trace/trace_syscalls.c       |    4 ++--
 tools/perf/builtin-trace.c          |    6 ------
 tools/perf/util/trace-event-parse.c |    9 +++++----
 3 files changed, 7 insertions(+), 12 deletions(-)

