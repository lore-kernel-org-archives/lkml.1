Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbZG3O5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbZG3O5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZG3O5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:57:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54594 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZG3O5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:57:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] scheduler fixes
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
       maxk@qualcomm.com, mingo@elte.hu
Date: Thu, 30 Jul 2009 10:57:17 -0400
Message-ID: <20090730145623.25226.29033.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1314bb58bbe2a2c146490c59986c511687543d3c:
  Gregory Haskins (1):
        sched: enhance the pre/post scheduling logic

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git sched/updates

Gregory Haskins (2):
      [RESEND] sched: Fully integrate cpus_active_map and root-domain code
      sched: fix race in cpupri introduced by cpumask_var changes

 kernel/sched.c        |    2 +-
 kernel/sched_cpupri.c |   15 ++++++++++++++-
 kernel/sched_fair.c   |   10 +++++++---
 kernel/sched_rt.c     |    7 -------
 4 files changed, 22 insertions(+), 12 deletions(-)


Regards,
-Greg
