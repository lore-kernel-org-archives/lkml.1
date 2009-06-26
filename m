Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbZFZO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbZFZO2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZFZO2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:28:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:42026 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZFZO2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VKmNlTAuqss2+2DIoVrIEl9fAr6/5CkWO9jtScJ0/V86epqRmUeouKnkB67NSULFUN
         3wrVvt1a54rSniYFPUHosZGCpbaAP4VFUMmAgJl2eq5vLJOE29rgYMVGkl1ohue3esO8
         +o3Iqu50sxfl359ncNxZuqn0Rp8L0yRHM13lk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] perfcounter: callchains with perf report
Date: Fri, 26 Jun 2009 16:27:59 +0200
Message-Id: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a first shot for the sorted callchains per entries handling
with per report.

I'll continue to improve it:

- symbol resolution
- profit we have a tree to display a better graph hierarchy
- let the user provide a limit for hit percentage, depth, number of
  backtraces, etc...
- better output
- colors
- and so on....

Thanks.

Frederic Weisbecker (2):
  perfcounter: prepare a small callchain framework
  perfcounter: print sorted callchains per histogram entries

 tools/perf/Makefile         |    1 +
 tools/perf/builtin-report.c |   87 +++++++++++++++++----
 tools/perf/perf.h           |    5 +
 tools/perf/util/callchain.c |  174 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |   33 ++++++++
 5 files changed, 284 insertions(+), 16 deletions(-)
 create mode 100644 tools/perf/util/callchain.c
 create mode 100644 tools/perf/util/callchain.h

