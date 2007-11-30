Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbXK3Trg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbXK3Trg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763920AbXK3TrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:47:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760614AbXK3TrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:47:14 -0500
Date: Fri, 30 Nov 2007 20:46:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       skumar@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, menage@google.com
Subject: Re: [PATCH] sched: cpu accounting controller (V2)
Message-ID: <20071130194647.GA24428@elte.hu>
References: <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <20071113074805.GA13499@linux.vnet.ibm.com> <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com> <20071129191737.GH5681@linux.vnet.ibm.com> <20071129113035.bbdf35db.akpm@linux-foundation.org> <20071129201833.GA18023@linux.vnet.ibm.com> <20071130124225.GM5681@linux.vnet.ibm.com> <475005F7.7080702@linux.vnet.ibm.com> <20071130135331.GA7145@elte.hu> <47505A53.8080906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47505A53.8080906@linux.vnet.ibm.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > thx. Have you done targeted testing of it as well? The (v2) patch is 
> > in sched-devel.git:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> > 	Ingo
> 
> Tested the patches on top of 2.6.24-rc3. The patches work fine. Ran 
> some simple tests like cpuspin (spin on the cpu), ran several tasks in 
> the same group and timed them. Compared their time stamps with 
> cpuacct.usage.
> 
> Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

thanks!

	Ingo
