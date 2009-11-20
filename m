Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZKTKNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZKTKNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZKTKNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:13:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZKTKNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:13:14 -0500
Date: Fri, 20 Nov 2009 11:13:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
Message-ID: <20091120101305.GA16781@elte.hu>
References: <4B064AF5.9060208@cn.fujitsu.com>
 <20091120081440.GA19778@elte.hu>
 <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
 <20091120083053.GB19778@elte.hu>
 <4B0657A4.2040606@cs.helsinki.fi>
 <20091120090134.GD19778@elte.hu>
 <84144f020911200115g14cfa3b5k959f8751001b8b35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020911200115g14cfa3b5k959f8751001b8b35@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Fri, Nov 20, 2009 at 11:01 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > But ... even without that, perf is really fast and is supposed to build
> > fine even in minimal (embedded) environments, so you can run it on the
> > embedded board too. That's useful to get live inspection features like
> > 'perf top', 'perf stat' and 'perf probe' anyway.
> 
> Maybe I'm just too damn lazy but if I don't go through the trouble of
> building my kernel on the box, I sure don't want to do that for perf
> either. [...]

Well you'll need 'perf' on that box anyway, to be able to do 'perf kmem 
record'.

	Ingo
