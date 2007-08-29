Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXH2IEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXH2IEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXH2IEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:04:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXH2IEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:04:33 -0400
Date: Wed, 29 Aug 2007 10:04:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keith.packard@intel.com>
Cc: Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070829080417.GB19386@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu> <1188361749.21502.123.camel@koto.keithp.com> <20070829044614.GA13225@elte.hu> <1188374249.21502.155.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188374249.21502.155.camel@koto.keithp.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Keith Packard <keith.packard@intel.com> wrote:

> Make sure the X server isn't running with the smart scheduler 
> disabled; that will cause precisely the symptoms you're seeing here. 
> In the normal usptream sources, you'd have to use '-dumbSched' as an X 
> server command line option.
> 
> The old 'scheduler' would run an entire X client's input buffer dry 
> before looking for requests from another client. Because glxgears 
> requests are small but time consuming, this can cause very long delays 
> between client switching.

on the old box where i've reproduced this i've got an ancient X version:

  neptune:~> X -version

  X Window System Version 6.8.2
  Release Date: 9 February 2005
  X Protocol Version 11, Revision 0, Release 6.8.2
  Build Operating System: Linux 2.6.9-22.ELsmp i686 [ELF]

is that old enough to not have the smart X scheduler?

on newer systems i dont see correctly updated glxgears output (probably 
the GLX bug you mentioned) so i cannot reproduce the bug.

Al, could you send us your 'X -version' output?

	Ingo
