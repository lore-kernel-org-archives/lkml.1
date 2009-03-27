Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZC0AKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZC0AKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbZC0AJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:09:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795AbZC0AJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:09:58 -0400
Date: Fri, 27 Mar 2009 01:08:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090327000802.GB28441@elte.hu>
References: <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326152815.GB6239@mit.edu> <20090326230240.GA18808@elte.hu> <20090326235936.GK6239@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326235936.GK6239@mit.edu>
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


* Theodore Tso <tytso@mit.edu> wrote:

> On Fri, Mar 27, 2009 at 12:02:40AM +0100, Ingo Molnar wrote:
> > This isnt me streaming gigs of data in and out of the system 
> > dirtying 90% of all RAM. This is a trivial workload barely 
> > scratching the RAM and CPU capabilities of the system.
> 
> Have you tried with maxcpus set to say, 2?  My guess is you won't see
> the problems in that case.

Note, my previous devel box was a single socket quad and it had such 
delays all the time as well. Havent tried it on a dual-core. (i dont 
have dual-core systems with enough RAM to be able to build a kernel 
purely in RAM)

	Ingo
