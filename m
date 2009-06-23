Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZFWIXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZFWIXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZFWIWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:22:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:43080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbZFWIWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:22:42 -0400
Date: Tue, 23 Jun 2009 08:21:58 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245703959.6167.16.camel@localhost.localdomain>
References: <1245703959.6167.16.camel@localhost.localdomain>
Subject: [tip:perfcounters/urgent] perf stat: Fix command option / manpage
Message-ID: <tip-dee412066aeb16c43cf31599948c1a1de385df56@git.kernel.org>
Git-Commit-ID: dee412066aeb16c43cf31599948c1a1de385df56
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 08:21:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dee412066aeb16c43cf31599948c1a1de385df56
Gitweb:     http://git.kernel.org/tip/dee412066aeb16c43cf31599948c1a1de385df56
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Tue, 23 Jun 2009 02:22:39 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 10:20:02 +0200

perf stat: Fix command option / manpage

-l is not supported, it should be -S for scale.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245703959.6167.16.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-stat.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c368a72..0d74346 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -8,8 +8,8 @@ perf-stat - Run a command and gather performance counter statistics
 SYNOPSIS
 --------
 [verse]
-'perf stat' [-e <EVENT> | --event=EVENT] [-l] [-a] <command>
-'perf stat' [-e <EVENT> | --event=EVENT] [-l] [-a] -- <command> [<options>]
+'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] <command>
+'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] -- <command> [<options>]
 
 DESCRIPTION
 -----------
@@ -40,7 +40,7 @@ OPTIONS
 -a::
         system-wide collection
 
--l::
+-S::
         scale counter values
 
 EXAMPLES
