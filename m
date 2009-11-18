Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZKRBtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZKRBtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZKRBts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:49:48 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61841 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZKRBtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:49:47 -0500
Date: Wed, 18 Nov 2009 10:49:51 +0900 (JST)
Message-Id: <20091118.104951.809240127838837992.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: peterz@infradead.org, walken@google.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091117172456.GA14749@elte.hu>
References: <20091117081817.GA7963@elte.hu>
	<1258448121.7816.29.camel@laptop>
	<20091117172456.GA14749@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Date: Tue, 17 Nov 2009 18:24:56 +0100

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2009-11-17 at 09:18 +0100, Ingo Molnar wrote:
> > > 
> > > Would you be interested in adding it as a 'perf bench futex' testcase? 
> > > That way kernel developers could monitor futex performance in the future 
> > > as well.
> > > 
> > > See 'perf bench' in the latest perf events tree:
> > > 
> > >   http://people.redhat.com/mingo/tip.git/README
> > > 
> > > Do 'cd tools/perf; make -j install' to install perf.
> > 
> > Darren has recently been putting a lot of effort in making a futex test
> > suite:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
> > 
> > Its not yet complete, but hopefully it will soon be :-)
> 
> Looks nice! Any futex performance measurements within it could be added 
> to perf bench - with standardized options and output, etc.

It is interesting for me, too.
Can I add your test programs to perf bench, Michel and Darren?
Of course, I'll do every odd job if you permit.

   Hitoshi

