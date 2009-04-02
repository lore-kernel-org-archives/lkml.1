Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbZDBBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbZDBBBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZDBBBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:01:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZDBBBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:01:03 -0400
Date: Thu, 2 Apr 2009 03:00:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-ID: <20090402010044.GA16092@elte.hu>
References: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401143622.b1885643.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 1 Apr 2009 17:03:38 -0400
> lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:
> 
> > On Thu, Mar 26, 2009 at 06:25:19PM -0700, Andrew Morton wrote:
> > > The JBD journal is a massive designed-in contention point.  It's why
> > > for several years I've been telling anyone who will listen that we need
> > > a new fs.  Hopefully our response to all these problems will soon be
> > > "did you try btrfs?".
> > 
> > Oh I look forward to the day when it will be safe to convert my mythtv
> > box from ext3 to btrfs.  Current kernels just have too much IO latency
> > with ext3 it seems.  Older kernels were more responsive, but probably
> > had other places they were less efficient.
> 
> Back in 2002ish I did a *lot* of work on IO latency, 
> reads-vs-writes, etc, etc (but not fsync - for practical purposes 
> it's unfixable on ext3-ordered)
> 
> Performance was pretty good.  From some of the descriptions I'm 
> seeing get tossed around lately, I suspect that it has regressed.
> 
> It would be useful/interesting if people were to rerun some of these
> tests with `echo anticipatory > /sys/block/sda/queue/scheduler'.

I'll test this (and the other suggestions) once i'm out of the merge 
window.

> Or with linux-2.5.60 :(

I probably wont test that though ;-)

Going back to v2.6.14 to do pre-mutex-merge performance tests was 
already quite a challenge on modern hardware.

	Ingo
