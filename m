Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZFVUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZFVUxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZFVUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:53:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:58918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZFVUxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:53:08 -0400
Subject: [PATCH -tip] perf_counter tools: fix perf stat command option
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 02:22:39 +0530
Message-Id: <1245703959.6167.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-l is not supported, it should be -S for scale

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
-- 
1.6.0.6



