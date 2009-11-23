Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZKWHdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZKWHdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZKWHdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:33:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57561 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZKWHdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:33:23 -0500
Date: Mon, 23 Nov 2009 08:33:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
Message-ID: <20091123073317.GA16628@elte.hu>
References: <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
 <20091120083053.GB19778@elte.hu>
 <4B0657A4.2040606@cs.helsinki.fi>
 <4B06590C.7010109@cn.fujitsu.com>
 <20091120090353.GE19778@elte.hu>
 <20091120144215.GH18283@ghostprotocols.net>
 <20091120164110.GA24183@elte.hu>
 <20091120175228.GD27926@ghostprotocols.net>
 <20091123065110.GC31758@elte.hu>
 <1258960941.4531.19.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258960941.4531.19.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > I havent tried this - is this really possible to do on an x86 box, 
> > with a typical distro? Can i install say Fedora PowerPC debuginfo 
> > packages on an x86 box, while also having the x86 debuginfo packages 
> > there?
> 
> The best option would be to allow to specify a chroot parameter, where 
> we can specify the embedded root filesystem on out machine.
> 
> I'm not even sure embedded distros even have this separate debug 
> package crazyness, you simply build the distro with or without 
> debuginfo.

yes - we could use -R/--root (which opreport has as well), as a 
mandatory path prefix to all DSO/debuginfo searches.

	Ingo
