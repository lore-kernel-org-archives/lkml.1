Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZBQVsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZBQVsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZBQVsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:48:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56173 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZBQVsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:48:37 -0500
Date: Tue, 17 Feb 2009 22:48:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090217214829.GB6976@elte.hu>
References: <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com> <20090216225108.GA15904@linux.vnet.ibm.com> <20090217094657.GA1845@elte.hu> <20090217140130.GA6761@linux.vnet.ibm.com> <20090217153925.GA2308@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217153925.GA2308@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Damien Wyart <damien.wyart@free.fr> wrote:

> Hello Paul,
> 
> > > There's no strong reason - we've been back and forth about RCU in
> > > the dynticks code. Mind sending a test patch for Damien to try?
> 
> > But of course!  ;-)
> 
> With this patch, the problem goes away and system activity 
> seems normal, both on the P4 with high load and on the recent 
> laptop.

Applied to tip:x86/urgent, thanks a lot for the patient testing 
and tracing!

	Ingo
