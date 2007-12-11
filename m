Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbXLKVYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbXLKVYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXLKVYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:24:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45275 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbXLKVYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:24:02 -0500
Date: Tue, 11 Dec 2007 22:23:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071211212352.GF6902@elte.hu>
References: <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org> <20071210105943.GA5370@elte.hu> <475D9BB5.20808@jlab.org> <20071211105149.GA24250@elte.hu> <475EAC81.1020408@jlab.org> <20071211155226.GA1056@elte.hu> <475EBD30.1010506@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EBD30.1010506@jlab.org>
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


* Jie Chen <chen@jlab.org> wrote:

> The following is pthread_sync output for 2.6.21.7-cfs-v24 #1 SMP 
> kernel.

> 2 threads:

> PARALLEL time =       11.106580 microseconds +/- 0.002460
> PARALLEL overhead =    0.617590 microseconds +/- 0.003409

> Output for Kernel 2.6.24-rc4 #1 SMP

> PARALLEL time =              19.668450 microseconds +/- 0.015782
> PARALLEL overhead =           9.157945 microseconds +/- 0.018217

ok, so the problem is that this PARALLEL time has an additional +9 usecs 
overhead, right? I dont see this myself on a Core2 CPU:

PARALLEL time =                           10.446933 microseconds +/- 0.078849
PARALLEL overhead =                       0.751732 microseconds +/- 0.177446

	Ingo
