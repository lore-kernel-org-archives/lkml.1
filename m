Return-Path: <linux-kernel-owner+w=401wt.eu-S935664AbXJSTAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935664AbXJSTAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764839AbXJSTAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:00:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51694 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762962AbXJSTAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:00:46 -0400
Date: Fri, 19 Oct 2007 21:00:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler accounting fix
Message-ID: <20071019190032.GA31070@elte.hu>
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

it contains a single onliner fix: Christian Borntraeger noticed a 
guest-cputime over-accounting bug (introduced via the recent v2.6.24 
scheduler merge).

Thanks!

	Ingo

------------------>
Christian Borntraeger (1):
      sched: fix guest time accounting going faster than user time accounting

 array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
