Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZAFIug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZAFIug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZAFIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:50:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57402 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZAFIuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:50:24 -0500
Date: Tue, 6 Jan 2009 09:50:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       penberg@cs.helsinki.fi, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: Remove the relay version of kmemtrace.
Message-ID: <20090106085001.GC29917@elte.hu>
References: <20090105191330.GA1498@elte.hu> <1231186198-15437-1-git-send-email-eduard.munteanu@linux360.ro> <20090106004741.GF6531@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106004741.GF6531@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > +++ b/kernel/trace/Kconfig
> > @@ -268,7 +268,6 @@ config KMEMTRACE
> >  	bool "Trace SLAB allocations"
> >  	select TRACING
> >  	select MARKERS
> > -	select RELAY

> BTW, I've kept the MARKERS dependency from the previous CONFIG entry of 
> kmemtrace. Looks like it is not needed anymore. So I will drop it...

good point, i've added that to Eduard's patch.

	Ingo
