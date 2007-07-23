Return-Path: <linux-kernel-owner+w=401wt.eu-S936372AbXGWVCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936372AbXGWVCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbXGWVCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:02:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761235AbXGWVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:02:40 -0400
Date: Mon, 23 Jul 2007 23:02:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: v2.6.22.1-rt5
Message-ID: <20070723210236.GA25104@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


we are pleased to announce the v2.6.22.1-rt5 kernel (collected and 
assembled by Thomas), which can be downloaded from the usual place:
  
  http://redhat.com/~mingo/realtime-preempt/
  
more info about the -rt patchset can be found in the RT wiki:
   
  http://rt.wiki.kernel.org

Changes since -rt4:

 - MM fix: PCP pages locking (Peter Zijlstra)

 - yield() fix: remove stale RCU-unlock (Daniel Walker)

 - dont do check_pgt_cache() in idle (found by Daniel Walker)

 - moved 8 patches, created 6 new patches out of larger patches to 
   make the -rt queue more bisectable (Daniel Walker)

 - cleanup (Daniel Walker)

 - fix the latency tracer under paravirt

to build a 2.6.22.1-rt5 tree, the following patches should be applied:
  
  http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
  http://redhat.com/~mingo/realtime-preempt/patch-2.6.22.1-rt5
  
	Ingo
