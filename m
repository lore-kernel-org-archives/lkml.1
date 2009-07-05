Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZGESFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZGESFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZGESEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:04:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZGESEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:04:52 -0400
Date: Sun, 5 Jul 2009 20:04:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
Message-ID: <20090705180414.GA13567@elte.hu>
References: <20090703164225.GA21447@elte.hu> <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org> <4A4FC5D0.6090000@kernel.org> <20090705002709.GA28424@elte.hu> <1246773777.2325.113.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246773777.2325.113.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sun, 2009-07-05 at 02:27 +0200, Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > >  static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
> > > > +
> > > >  static int __initdata debug_print;
> > > > +#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
> > > > +
> > > > +
> > > 
> > > two blank lines?
> > 
> > ah, yes - i moved them around.
> > 
> > > > +#define BIOS_BUG_MSG KERN_WARNING \
> > > > +	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
> > > 
> > > No user for this
> > 
> > yeah. Mind sending a patch for these? (and any other things you 
> > might notice)
> 
> But why you did this stupidity.

Uhm, no. This was an unused define that i made later use of in:

  e3d0e69: x86: Further clean up of mtrr/generic.c

	Ingo
