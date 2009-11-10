Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZKJPEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZKJPEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZKJPEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:04:06 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63571 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbZKJPEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:04:05 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 0/3] perf bench: Make output more better
Date: Wed, 11 Nov 2009 00:03:59 +0900
Message-Id: <1257865442-20252-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series makes output of perf bench more better.
Current style, keeping user wait and print everything
suddenly after finish, is not good.
And current formatting for values are too ugly.

Example (case of messaging):
| % perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time:1.490 [sec]

Hitoshi Mitake (3):
  perf bench: Fix builtin-bench.c for more friendly output
  perf bench: Fix sched-pipe.c for more confortable output
  perf bench: Fix sched-message.c for more confortable output

 tools/perf/bench/sched-messaging.c |    6 +++---
 tools/perf/bench/sched-pipe.c      |   11 ++++++-----
 tools/perf/builtin-bench.c         |    4 ++++
 3 files changed, 13 insertions(+), 8 deletions(-)

