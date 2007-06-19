Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbXFSJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbXFSJBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXFSJB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:01:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbXFSJB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:01:27 -0400
Date: Tue, 19 Jun 2007 11:01:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -cfs] Fix cpu_load calculation error
Message-ID: <20070619090120.GC5746@elte.hu>
References: <20070618170114.GA21037@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618170114.GA21037@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> Ingo/Dmitry,
> 	I am resending the patch to fix cpu_load calculation error in 
> cfs v17, this time CCing lkml.

> v17 cpu_load calculation didn't take into account that a class's 
> delta_exec/fair may be stale because it could not get an opportunity 
> to run. This can lead to incorrect calculation of a class's load. This 
> patch removes load tracking from individual classes and instead 
> introduces a global per-cpu load tracking common to all classes in 
> kernel/sched.c itself.
> 
> Thanks to Dmitry for suggesting this idea.
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

thanks Srivatsa, i've applied this to the -v18 tree and everything's 
looking good so far!

	Ingo
