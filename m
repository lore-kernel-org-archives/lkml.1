Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXJMJmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXJMJmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbXJMJl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:41:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbXJMJl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:41:57 -0400
Date: Sat, 13 Oct 2007 11:41:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rok Markovic <kernel@kanardia.eu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
Message-ID: <20071013094142.GA16098@elte.hu>
References: <470F27DA.9020307@kanardia.eu> <20071012083551.GA17937@elte.hu> <470FB4F4.60707@kanardia.eu> <20071012175831.GA27420@elte.hu> <470FD96A.8040505@kanardia.eu> <20071013055922.GB26370@elte.hu> <47109008.5090405@kanardia.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47109008.5090405@kanardia.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rok Markovic <kernel@kanardia.eu> wrote:

> Hi
> 
> I have recompiled kernel with OPROFILE disabled. I am sending in 
> attachment /proc/interrupts (i ran it 3 times with 2 sec delay) and 
> netconsole log. Lockup in the lock is software made with ./lockup. The 
> kernel still locks 4-5minutes after boot without any further messages 
> (waited more than 2 minutes). Any ideas?

no good ideas :-( I suspect this one:

  [  185.600900] hdc: lost interrupt

was a side-effect of lockup.c too?

does the lockup go away if you boot with maxcpus=1?

	Ingo
