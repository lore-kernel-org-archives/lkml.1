Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZAKJxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZAKJxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZAKJxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:53:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42946 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZAKJxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:53:42 -0500
Date: Sun, 11 Jan 2009 10:53:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
Message-ID: <20090111095325.GA32409@elte.hu>
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu> <493E8246.1090309@novell.com> <20081212113415.GH32640@elte.hu> <20081212114952.GA16976@elte.hu> <4958EEB6.5020105@novell.com> <49591331.9080403@novell.com> <20090111040121.GD28520@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111040121.GD28520@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Hi Ingo,
> >   I have rebased the series against tip/cpus4096 as of today.  I
> > built/boot this kernel for both SMP/UP on a 4-way x86_64 box, and they
> > look sane.  Let me know if they still look broken to you.

yes, i still get build failures:

kernel/sched_rt.c:574: error: 'struct rq' has no member named 'cpu'
kernel/sched_rt.c:619: error: 'rq' undeclared (first use in this function)
kernel/sched_rt.c:619: error: (Each undeclared identifier is reported only once
kernel/sched_rt.c:619: error: for each function it appears in.)
kernel/sched_rt.c:667: error: 'rq' undeclared (first use in this function)

so i've excluded tip/sched/rt from tip/master for now.

	Ingo
