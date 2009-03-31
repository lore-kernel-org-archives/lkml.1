Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbZCaNxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbZCaNxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbZCaNxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:53:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39637 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbZCaNxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:53:41 -0400
Date: Tue, 31 Mar 2009 15:53:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core kernel cleanups
Message-ID: <20090331135324.GA22050@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Américo Wang (1):
      ptrace: remove a useless goto


 kernel/ptrace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index c9cf48b..1379559 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -612,8 +612,6 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
 		goto out_put_task_struct;
 
 	ret = arch_ptrace(child, request, addr, data);
-	if (ret < 0)
-		goto out_put_task_struct;
 
  out_put_task_struct:
 	put_task_struct(child);
