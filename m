Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZJBSpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZJBSpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZJBSpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:45:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59503 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbZJBSpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:45:46 -0400
Date: Fri, 2 Oct 2009 20:45:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
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
Message-ID: <20091002184549.GS31616@kernel.dk>
References: <20091002145610.GD31616@kernel.dk> <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain> <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk> <20091002175629.GA14860@elte.hu> <20091002180437.GL31616@kernel.dk> <20091002183649.GE8161@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002183649.GE8161@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02 2009, Theodore Tso wrote:
> On Fri, Oct 02, 2009 at 08:04:37PM +0200, Jens Axboe wrote:
> > > i'd say 'latency' describes it even better. 'interactivity' as a term is 
> > > a bit overladen.
> > 
> > I'm not too crazy about it either. How about just using 'desktop' since
> > this is obviously what we are really targetting? 'latency' isn't fully
> > descriptive either, since it may not necessarily provide the best single
> > IO latency (noop would).
> 
> As Linus has already pointed out, it's not necessarily "desktop"
> versus "server".  There will be certain high frequency transaction
> database workloads (for example) that will very much care about
> latency.  I think "low_latency" may be the best term to use.

Not necessarily, but typically it will be. As already noted, I don't
think latency itself is a very descriptive term for this.

-- 
Jens Axboe

