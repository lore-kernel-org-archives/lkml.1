Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZJBO5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZJBO5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZJBO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:57:45 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35965 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZJBO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:57:44 -0400
Date: Fri, 2 Oct 2009 16:57:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002145748.GE31616@kernel.dk>
References: <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <1254494742.7307.37.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254494742.7307.37.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02 2009, Mike Galbraith wrote:
> On Fri, 2009-10-02 at 07:24 -0700, Linus Torvalds wrote:
> > 
> > On Fri, 2 Oct 2009, Jens Axboe wrote:
> > > 
> > > It's really not that simple, if we go and do easy latency bits, then
> > > throughput drops 30% or more.
> > 
> > Well, if we're talking 500-950% improvement vs 30% deprovement, I think 
> > it's pretty clear, though. Even the server people do care about latencies. 
> > 
> > Often they care quite a bit, in fact.
> > 
> > And Mike's patch didn't look big or complicated.
> 
> But it is a hack.  (thought about and measured, but hack nonetheless)
> 
> I haven't tested it on much other than reader vs streaming writer.  It
> may well destroy the rest of the IO universe. I don't have the hw to
> even test any hairy chested IO.

I'll get a desktop box going on this too. The plan is to make the
latency as good as we can without making too many stupid decisions in
the io scheduler, then we can care about the throughput later. Rinse
and repeat.

-- 
Jens Axboe

