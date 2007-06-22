Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbXFVWVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbXFVWVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbXFVWVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:21:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbXFVWVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:21:17 -0400
Date: Sat, 23 Jun 2007 00:20:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070622222036.GC27445@elte.hu>
References: <20070622220202.GA16872@elte.hu> <200706230109.08310.caglar@pardus.org.tr> <200706230116.29615.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706230116.29615.caglar@pardus.org.tr>
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> > kernel/sched.c:745:28: sched_idletask.c: No such file or directory
> 
> Ahh and this happens with [1], grabbing sched_idletask.c from .18 one solves 
> the problem...

oops, indeed - i've fixed up the -git patch:

  http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22-git-v18.patch

	Ingo
