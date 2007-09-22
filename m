Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbXIVBTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbXIVBTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 21:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXIVBTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 21:19:30 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:55591 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbXIVBT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 21:19:29 -0400
Date: Fri, 21 Sep 2007 21:19:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
In-Reply-To: <20070922003235.GJ9059@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0709212115160.4791@gandalf.stny.rr.com>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
 <20070910183412.GC3819@linux.vnet.ibm.com> <20070921152048.GF15697@goodmis.org>
 <20070921230343.GE9059@linux.vnet.ibm.com> <20070922003235.GJ9059@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> >
> > In any case, I will be looking at the scenarios more carefully.  If
> > it turns out that GP_STAGES can indeed be cranked down a bit, well,
> > that is an easy change!  I just fired off a POWER run with GP_STAGES
> > set to 3, will let you know how it goes.
>
> The first attempt blew up during boot badly enough that ABAT was unable
> to recover the machine (sorry, grahal!!!).  Just for grins, I am trying
> it again on a machine that ABAT has had a better record of reviving...

This still frightens the hell out of me. Going through 15 states and
failing. Seems the CPU is holding off writes for a long long time. That
means we flipped the counter 4 times, and that still wasn't good enough?

Maybe I'll boot up my powerbook to see if it has the same issues.

Well, I'm still finishing up on moving into my new house, so I wont be
available this weekend.

Thanks,

-- Steve

