Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbXKTUjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbXKTUjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761501AbXKTUjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:39:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbXKTUjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:39:41 -0500
Date: Tue, 20 Nov 2007 21:39:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Greg KH <gregkh@suse.de>,
       David <david@unsolicited.net>,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071120203919.GB10008@elte.hu>
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <473F88B0.1030309@goop.org> <20071119232252.GC3528@suse.de> <47423B26.1090607@goop.org> <20071120060525.GF20436@elte.hu> <20071120170519.GB15954@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120170519.GB15954@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> > but we only have cpu_clock() from v2.6.23 onwards - so we should not 
> > apply the original patch to v2.6.22. (we should not have applied 
> > your patch that started the mess to begin with - but that's another 
> > matter.)
> 
> Well, I can easily back that one out, if that is easier than adding 2 
> more patches to try to fix up the mess here.
> 
> Let me know if you feel that would be best.

i'd leave it alone - doing that we have in essence the softlockup 
detector turned off. Reverting to the older version might trigger false 
positives that need the new stuff.

	Ingo
