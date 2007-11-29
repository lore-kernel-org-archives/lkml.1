Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbXK2TVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbXK2TVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762257AbXK2TV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:21:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772AbXK2TV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:21:28 -0500
Date: Thu, 29 Nov 2007 20:20:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dhaval@linux.vnet.ibm.com,
       skumar@linux.vnet.ibm.com
Subject: Re: [PATCH] sched: cpu accounting controller
Message-ID: <20071129192058.GC5238@elte.hu>
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <20071113074805.GA13499@linux.vnet.ibm.com> <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com> <20071129191737.GH5681@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129191737.GH5681@linux.vnet.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> Paul,
> 	Sorry about the delay in getting back to this thread. I realized
> very recently that cpuacct controller has been removed from Linus's tree
> and have attempted to rework it as per our discussions.
> 
> Linus/Ingo,
> 	Commit cfb5285660aad4931b2ebbfa902ea48a37dfffa1 removed a 
> usefull feature for us, which provided a cpu accounting resource 
> controller. This feature would be usefull if someone wants to group 
> tasks only for accounting purpose and doesnt really want to exercise 
> any control over their cpu consumption.

ok, this looks certainly doable for v2.6.24. I've added it to the 
scheduler fixes queue and will let it brew there for a few days and send 
it to Linus after that if everything goes fine - unless anyone objects. 
This is pre-existing, tested code so the risk is small.

	Ingo
