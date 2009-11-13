Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZKMEXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZKMEXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 23:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZKMEXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 23:23:07 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50373 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZKMEXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 23:23:06 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 0/4] perf bench: Add new subsystem "mem" and new suite "memcpy"
Date: Fri, 13 Nov 2009 13:23:02 +0900
Message-Id: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds new subysystem "mem"
and new suite "memcpy" for it.

I've not added the memcpy() of Nehalem oriented optimization
by Ling Ma. The original memcpy() contains a lot of
separated inline assembly, and label with name of single digit
caused conflict with other part of assembled code.
So I'll rewrite it for readability and post
the patch to add memcpy() by Ling later.

This is first version. Could you review this?

Hitoshi Mitake (4):
  perf bench: Add new subsystem and new suite, bench/mem-memcpy.c
  perf bench: Modify bench/bench.h for new prototype:
    bench_mem_memcpy()
  perf bench: Modify builtin-bench.c for new subsystem "mem"
  perf bench: Modify Makefile to build new subsystem "mem"

 tools/perf/Makefile           |    3 +-
 tools/perf/bench/bench.h      |    1 +
 tools/perf/bench/mem-memcpy.c |  258 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c    |   14 ++-
 4 files changed, 274 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/bench/mem-memcpy.c

