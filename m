Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYKRVD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYKRVD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYKRVDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:03:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39335 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYKRVDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:03:49 -0500
Date: Tue, 18 Nov 2008 22:03:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
	field
Message-ID: <20081118210344.GC11490@elte.hu>
References: <20081118084755.GK17838@elte.hu> <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com> <20081118145154.GC30358@elte.hu> <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com> <20081118151326.GH30358@elte.hu> <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com> <20081118155045.GJ30358@elte.hu> <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com> <20081118164019.GA18620@elte.hu> <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/18 Ingo Molnar <mingo@elte.hu>:
> > Would be nice to have the dynamic allocation straight away
> 
> 2008/11/18 Steven Rostedt <rostedt@goodmis.org>:
> > I would recommend using a static array
> 
> :-)

hey, look at the bright side of it: whichever variant you pick, if it 
goes wrong, you'll always have someone else to blame for that 
unbelievably stupid suggestion ;-)

	Ingo
