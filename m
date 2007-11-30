Return-Path: <linux-kernel-owner+w=401wt.eu-S934749AbXK3Nfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749AbXK3Nfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934050AbXK3Nfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:35:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45680 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759648AbXK3Nfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:35:43 -0500
Date: Fri, 30 Nov 2007 14:34:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dhaval@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       skumar@linux.vnet.ibm.com, menage@google.com,
       torvalds@linux-foundation.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] sched: cpu accounting controller (V2)
Message-ID: <20071130133455.GA29679@elte.hu>
References: <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <20071113074805.GA13499@linux.vnet.ibm.com> <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com> <20071129191737.GH5681@linux.vnet.ibm.com> <20071129113035.bbdf35db.akpm@linux-foundation.org> <20071129201833.GA18023@linux.vnet.ibm.com> <20071130124225.GM5681@linux.vnet.ibm.com> <20071130123513.GA16690@elte.hu> <20071130130903.GA30772@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130130903.GA30772@linux.vnet.ibm.com>
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

> On Fri, Nov 30, 2007 at 01:35:13PM +0100, Ingo Molnar wrote:
> > * Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> > 
> > > Here's V2 of the cpu acccounting controller patch, which makes 
> > > accounting scale better on SMP systems by splitting the usage counter 
> > > to be per-cpu.
> > 
> > thanks, applied. But you dont seem to have incorporated all of the 
> > review feedback from Andrew. (such as making cpuacct_subsys static)
> 
> cpuacct_subsys can't be made static, as I have pointed out at 
> http://marc.info/?l=linux-kernel&m=119636730930886. [...]

ah, ok - i missed that.

	Ingo
