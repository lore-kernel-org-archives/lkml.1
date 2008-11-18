Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYKRVB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYKRVB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYKRVBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:01:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbYKRVBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:01:20 -0500
Date: Tue, 18 Nov 2008 22:01:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
	field
Message-ID: <20081118210111.GB11490@elte.hu>
References: <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com> <20081118151326.GH30358@elte.hu> <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com> <20081118155045.GJ30358@elte.hu> <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com> <20081118164019.GA18620@elte.hu> <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com> <alpine.DEB.1.10.0811181151010.15003@gandalf.stny.rr.com> <c62985530811180858u397fbac8h63f61b6d816abb46@mail.gmail.com> <c62985530811180900k8687deye092862bd04f467c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811180900k8687deye092862bd04f467c@mail.gmail.com>
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

> 2008/11/18 Frédéric Weisbecker <fweisbec@gmail.com>:
> > 2008/11/18 Steven Rostedt <rostedt@goodmis.org>:
> >> How about a compromise, start off the patch series getting it working with
> >> task struct static array, and then finish the series with the dynamic
> >> array.
> >>
> >> This is my development model, because it lets me know where the bugs are
> >> better. If we find some strange bug, this can help pin point via a bisect
> >> if the bug is with the general code, or with the use of a dynamic array.
> >>
> >> Just my preference ;-)
> >
> >
> > Ooh. I first agreed with Ingo's arguments about the fact that distros
> > can enable it whithout worrying.
> > But as I read your message, I guess that would be better to start with
> > static arrays to better find the bugs,
> > state by state...
> >
> > Ingo, what do you think?
> >
> 
> And then a last state with dynamic arrays...

it's your call really, either way is fine as long as the end result 
works! :-)

Generally it's indeed much easier to do as small steps as possible, 
and to validate every step in practice.

	Ingo
