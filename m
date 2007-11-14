Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbXKNTFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbXKNTFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXKNTFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:05:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbXKNTFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:05:37 -0500
Date: Wed, 14 Nov 2007 20:05:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071114190501.GA5768@elte.hu>
References: <200711112058.28043.rjw@sisk.pl> <20071114112001.GA13870@elte.hu> <20071114173611.GR19691@waste.org> <20071114183952.GS19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114183952.GS19691@waste.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> > > [   61.245190] rc.sysinit used greatest stack depth: 1680 bytes left
> > > [   61.386859] list_add corruption. prev->next should be next (407d973c), but was 418cf818. (prev=41877098).
> > > [   61.396328] ------------[ cut here ]------------
> > > [   61.400910] kernel BUG at lib/list_debug.c:33!
> > > [   61.405330] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
> > > 
> > > looks like memory corruption of some sort and it's reproducible. Picking 
> > > CONFIG_SLUB makes the crash go away. Booting v2.6.23 with the same 
> > > .config works fine.
> > 
> > Hmmm, the changes in SLOB since v2.6.23 are all trivial. I'll try to 
> > reproduce it with your config, but it doesn't seem promising.
> 
> Couldn't reproduce it here, let me know if you get anywhere with your 
> bisect.

the bug went away - and the only thing i did was a networking config 
tweak. So maybe something in networking corrupts memory? I'm not sure i 
can restore the old state. (i had lots of problems with net interface 
renaming not working in .24)

	Ingo
