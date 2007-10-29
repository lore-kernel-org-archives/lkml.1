Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXJ2Xec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXJ2Xec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXJ2XeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:34:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXJ2XeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:34:23 -0400
Date: Tue, 30 Oct 2007 00:34:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fix
Message-ID: <20071029233417.GA14143@elte.hu>
References: <20071029203923.GA9314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029203923.GA9314@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, this is a followup git pull request for a single fix:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Frans Pop has tested a fix from Balbir Singh that (finally) resolves the 
procps CPU accounting bug. The fix you pulled earlier today was correct 
but it solved only half of the problem.

	Ingo

------------------>
Balbir Singh (1):
      sched: fix /proc/<PID>/stat stime/utime monotonicity, part 2

 fs/proc/array.c       |    3 ++-
 include/linux/sched.h |    2 +-
 kernel/fork.c         |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)
