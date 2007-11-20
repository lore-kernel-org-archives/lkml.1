Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbXKTWRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbXKTWRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761941AbXKTWQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:16:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57385 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761783AbXKTWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:16:54 -0500
Date: Tue, 20 Nov 2007 14:06:10 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, David <david@unsolicited.net>,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071120220610.GB19101@kroah.com>
References: <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <473F88B0.1030309@goop.org> <20071119232252.GC3528@suse.de> <47423B26.1090607@goop.org> <20071120060525.GF20436@elte.hu> <20071120170519.GB15954@kroah.com> <20071120203919.GB10008@elte.hu> <20071120210315.GC13160@kroah.com> <20071120214927.GB24156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120214927.GB24156@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 10:49:27PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, Nov 20, 2007 at 09:39:19PM +0100, Ingo Molnar wrote:
> > > 
> > > * Greg KH <greg@kroah.com> wrote:
> > > 
> > > > > but we only have cpu_clock() from v2.6.23 onwards - so we should not 
> > > > > apply the original patch to v2.6.22. (we should not have applied 
> > > > > your patch that started the mess to begin with - but that's another 
> > > > > matter.)
> > > > 
> > > > Well, I can easily back that one out, if that is easier than adding 2 
> > > > more patches to try to fix up the mess here.
> > > > 
> > > > Let me know if you feel that would be best.
> > > 
> > > i'd leave it alone - doing that we have in essence the softlockup 
> > > detector turned off. Reverting to the older version might trigger false 
> > > positives that need the new stuff.
> > 
> > Ok, I'll see if the current round of patches fix up everyone 
> > complaints :)
> 
> so just to reiterate, to make sure we have the same plans: lets leave 
> v2.6.22 and earlier kernels alone - and lets strive for the latest 
> patches and code for v2.6.23 (and v2.6.24, evidently).

Yes, that sounds fine to me.

thanks,

greg k-h
