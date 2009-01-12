Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbZALWDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbZALWDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZALWDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:03:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48021 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZALWDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:03:42 -0500
Date: Mon, 12 Jan 2009 23:03:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112220326.GB12462@elte.hu>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com> <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain> <20090112205259.GA5303@elte.hu> <64bb37e0901121355o78815c9dp5d4753c04886adc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0901121355o78815c9dp5d4753c04886adc7@mail.gmail.com>
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


* Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> On Mon, Jan 12, 2009 at 9:52 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > The reason why we wanted to re-test the functional changes was that
> > Torsten's crash looks very weird: double Call Trace line, a crash in the
> > scsi/ata code, showing the after-effects of some sort of memory corruption
> > there.
> 
> The double Call Trace: line was a copy&paste error on my part. Its not
> there in the original oops.
> 
> Sorry for that...

ah, ok - that's fine.

I was just wondering whether it was two CPUs crashing at once and 
producing an overlap - or something like that. (although typically in that 
case we dont get such nice line duplication - we get totally garbled 
output of the two oopses superimposed.)

It's just that when an oops looks weird we have to look at every small 
detail, to be able to imagine the unimaginable.

Bugs you cannot even imagine are the toughest nuts usually, as the process 
of debugging narrows imagination usually - often it involves repetitive 
automatisms which are not helpful in expanding your thoughts to cover 
tricky, unusual bugs.

If an oops looks difficult there's a way out of that trap: co-debug in 
duos if you can - the same folks rarely get unimaginative for the very 
same detail. (Or put it aside and leave it for the next morning - to flush 
out the invisible temporary mental dead-ends one has installed 
subconsciously and which are blocking you from reaching the real 
solution.)

	Ingo
