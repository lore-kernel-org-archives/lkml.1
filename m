Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYJ2IgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYJ2IgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYJ2If6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:35:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41135 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYJ2If5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:35:57 -0400
Date: Wed, 29 Oct 2008 09:35:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: fix current_tracer error return
Message-ID: <20081029083541.GD6364@elte.hu>
References: <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com> <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com> <c62985530810280835k66d3ab87qd1783a0135228174@mail.gmail.com> <alpine.DEB.1.10.0810281140420.30971@gandalf.stny.rr.com> <c62985530810281115n5e40539ek1a486a0b909e339c@mail.gmail.com> <alpine.DEB.1.10.0810281429170.15590@gandalf.stny.rr.com> <c62985530810281734k578f1c2dka79ad045abb8bb93@mail.gmail.com> <alpine.DEB.1.10.0810282052300.26466@gandalf.stny.rr.com> <c62985530810281809y115198e1o34800e80c691c302@mail.gmail.com> <alpine.DEB.1.10.0810282111000.26466@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810282111000.26466@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 29 Oct 2008, Fr?d?ric Weisbecker wrote:
> > >> Thanks. I guess this bug was there for several days. But since I
> > >
> > > But this was not a bug :-/
> > >
> > > I believe I purposely set it that way. The bug was that you did not know
> > > that you could enable it with /proc/sys/kernel/ftrace_enabled ;-)
> > 
> > Ah ok. I better understand now.
> > But IMHO I guess that would better for developpers who will use
> > it to have something directly enabled whithout touching this file at each start.
> 
> Yep, and that's why I have no objections with the patch ;-)

it's in tracing/urgent now, so all should be well now.

	Ingo
