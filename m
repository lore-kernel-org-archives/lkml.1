Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbZFDLXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbZFDLXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbZFDLWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:22:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:47566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZFDLWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:22:41 -0400
Date: Thu, 4 Jun 2009 11:21:46 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, yong.y.wang@intel.com,
       yong.y.wang@linux.intel.com, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, efault@gmx.de, yong.y.wang@intel.com,
       yong.y.wang@linux.intel.com, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090603084225.GA6553@ywang-moblin2.bj.intel.com>
References: <20090603084225.GA6553@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter: Documentation update
Message-ID: <tip-3aff27ca84fa94311ae99189e54fed8d83b69fc1@git.kernel.org>
Git-Commit-ID: 3aff27ca84fa94311ae99189e54fed8d83b69fc1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 11:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aff27ca84fa94311ae99189e54fed8d83b69fc1
Gitweb:     http://git.kernel.org/tip/3aff27ca84fa94311ae99189e54fed8d83b69fc1
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Wed, 3 Jun 2009 16:42:25 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 13:20:12 +0200

perf_counter: Documentation update

The 'nmi' bit is no longer there.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20090603084225.GA6553@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/design.txt |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/Documentation/perf_counter/design.txt b/Documentation/perf_counter/design.txt
index 9930c4b..d325076 100644
--- a/Documentation/perf_counter/design.txt
+++ b/Documentation/perf_counter/design.txt
@@ -48,7 +48,6 @@ struct perf_counter_hw_event {
         __u32                   read_format;
 
         __u64                   disabled       :  1, /* off by default        */
-                                nmi            :  1, /* NMI sampling          */
                                 inherit        :  1, /* children inherit it   */
                                 pinned         :  1, /* must always be on PMU */
                                 exclusive      :  1, /* only group on PMU     */
@@ -195,12 +194,6 @@ The 'disabled' bit specifies whether the counter starts out disabled
 or enabled.  If it is initially disabled, it can be enabled by ioctl
 or prctl (see below).
 
-The 'nmi' bit specifies, for hardware events, whether the counter
-should be set up to request non-maskable interrupts (NMIs) or normal
-interrupts.  This bit is ignored if the user doesn't have
-CAP_SYS_ADMIN privilege (i.e. is not root) or if the CPU doesn't
-generate NMIs from hardware counters.
-
 The 'inherit' bit, if set, specifies that this counter should count
 events on descendant tasks as well as the task specified.  This only
 applies to new descendents, not to any existing descendents at the
