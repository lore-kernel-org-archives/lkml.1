Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbXKTXPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbXKTXPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXKTXPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:15:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38408
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbXKTXPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:15:39 -0500
Date: Tue, 20 Nov 2007 15:15:38 -0800 (PST)
Message-Id: <20071120.151538.68704351.davem@davemloft.net>
To: mingo@elte.hu
Cc: greg@kroah.com, jeremy@goop.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       jkohen@users.sourceforge.net, akpm@linux-foundation.org,
       david@unsolicited.net
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120214927.GB24156@elte.hu>
References: <20071120203919.GB10008@elte.hu>
	<20071120210315.GC13160@kroah.com>
	<20071120214927.GB24156@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Nov 2007 22:49:27 +0100

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

I've validated that those patches make 2.6.23 behave on my
Niagara box.

Thanks.
