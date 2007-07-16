Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbXGPHxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbXGPHxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXGPHxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:53:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXGPHxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:53:37 -0400
Date: Mon, 16 Jul 2007 09:53:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull request] scheduler updates
Message-ID: <20070716075331.GA22405@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

this includes low-risk changes that improve comments, remove dead code 
and fix whitespace/style problems.

Thanks!

	Ingo

--------------->
Ingo Molnar (5):
      sched: remove dead code from task_stime()
      sched: improve weight-array comments
      sched: document prio_to_wmult[]
      sched: prettify prio_to_wmult[]
      sched: fix up fs/proc/array.c whitespace problems

 fs/proc/array.c |   53 ++++++++++++++++++++++++++---------------------------
 kernel/sched.c  |   27 ++++++++++++++++++---------
 2 files changed, 44 insertions(+), 36 deletions(-)
