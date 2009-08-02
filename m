Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZHBTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZHBTzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZHBTzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:55:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZHBTzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:55:41 -0400
Date: Sun, 2 Aug 2009 21:55:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to
	/etc/perfconfig/symbols.skip
Message-ID: <20090802195533.GE24486@elte.hu>
References: <20090728001041.GG28349@ghostprotocols.net> <2c0942db0907272058h3e1fc583w77925d0cc761c47f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0907272058h3e1fc583w77925d0cc761c47f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ray Lee <ray-lk@madrabbit.org> wrote:

> On Mon, Jul 27, 2009 at 5:10 PM, Arnaldo Carvalho de
> Melo<acme@redhat.com> wrote:
> > This also paves the way to add more symbol lists to be filtered out,
> > spinlock anyone?
> 
> Generally, the way I've found is best to handle things like this is to either:
> 
> A. Have a fall-back list to use if the file isn't found, or
> B. Start with the fall-back list of symbols to filter, then add to
> them via /etc/... and ~/.perf/...
> 
> I like approaching things from the 'everything works even in a
> broken/hasty installation' point of view, and it's paid off for me.
> Sane defaults are a wonderfully useful thing.

Agreed.

Also, i'd not pollute /etc just yet, please lets define a good 
default built-in list like we have now, and perhaps enable the 
extension of it via .perf/config.

Tools should work well by default.

	Ingo
