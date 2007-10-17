Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbXJQO3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbXJQO3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXJQO3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:29:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbXJQO3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:29:39 -0400
Date: Wed, 17 Oct 2007 16:29:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20071017142935.GA10766@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

4 fixes - and one of the fixes could resolve the group-scheduler crashes 
that were reported. Thanks,

	Ingo

------------------>
Dhaval Giani (1):
      sched: fix !SYSFS build breakage

Ingo Molnar (1):
      sched: fix new task startup crash

Ken Chen (1):
      sched: fix improper load balance across sched domain

Milton Miller (1):
      sched: more robust sd-sysctl entry freeing

 include/linux/sched.h |    2 ++
 kernel/sched.c        |   39 ++++++++++++++++++++++++++++++++-------
 kernel/user.c         |   23 +++++++++++++++--------
 3 files changed, 49 insertions(+), 15 deletions(-)
