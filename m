Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYAVRH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYAVRH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYAVRHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:07:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYAVRHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:07:14 -0500
Date: Tue, 22 Jan 2008 18:07:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: don't take a mutex from interrupt context
Message-ID: <20080122170700.GA6245@elte.hu>
References: <20080122023626.GA12213@darkstar.te-china.tietoenator.com> <1201019138.6341.24.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201019138.6341.24.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > WARNING: at kernel/mutex.c:134 mutex_lock_nested+0x277/0x290()

> Subject: sched: don't take a mutex from interrupt context
> 
> print_cfs_stats is callable from interrupt context (sysrq), hence it 
> should not take mutexes. Change it to use RCU since the task group 
> data is RCU freed anyway.

thanks Peter, applied this to sched-devel.git.

	Ingo
