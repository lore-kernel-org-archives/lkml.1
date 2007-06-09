Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbXFIVFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbXFIVFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 17:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbXFIVF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 17:05:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43033 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357AbXFIVFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 17:05:25 -0400
Date: Sat, 9 Jun 2007 23:05:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: v2.6.21.4-rt11
Message-ID: <20070609210507.GA29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce the v2.6.21.4-rt11 kernel, which can be 
downloaded from the usual place:
 
     http://people.redhat.com/mingo/realtime-preempt/
  
more info about the -rt patchset can be found in the RT wiki:
   
     http://rt.wiki.kernel.org

-rt11 is a bit more experimental than usual: it includes the CFS 
scheduler. Several people have suggested the inclusion of CFS into the 
-rt tree: the determinism of the CFS scheduler is a nice match to the 
determinism offered by PREEMPT_RT. The port of CFS to -rt was done by 
Dinakar Guniguntala. Tested on i686 and x86_64.
 
to build a 2.6.21.4-rt11 tree, the following patches should be applied:
  
    http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.4.tar.bz2
    http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt11
  
	Ingo
