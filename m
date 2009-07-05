Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZGEA15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZGEA15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 20:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZGEA1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 20:27:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZGEA1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 20:27:48 -0400
Date: Sun, 5 Jul 2009 02:27:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
Message-ID: <20090705002709.GA28424@elte.hu>
References: <20090703164225.GA21447@elte.hu> <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org> <4A4FC5D0.6090000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4FC5D0.6090000@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> >  static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
> > +
> >  static int __initdata debug_print;
> > +#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
> > +
> > +
> 
> two blank lines?

ah, yes - i moved them around.

> > +#define BIOS_BUG_MSG KERN_WARNING \
> > +	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
> 
> No user for this

yeah. Mind sending a patch for these? (and any other things you 
might notice)

	Ingo
