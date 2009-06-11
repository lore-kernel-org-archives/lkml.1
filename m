Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZFKOBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZFKOBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZFKOAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:00:55 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49655 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZFKOAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:00:54 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XSu+nUafecwltU95GIQFx
Date: Thu, 11 Jun 2009 07:00:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611140038.GB11199@atomide.com>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611132134.GA11199@atomide.com> <20090611133736.GP795@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611133736.GP795@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [090611 06:38]:
> On Thu, Jun 11, 2009 at 06:21:35AM -0700, Tony Lindgren wrote:
> > We've done this for two merge windows now for omap patches where the
> > patches have been posted to linux-arm-kernel, then they go into the
> > for-next tree, and then Russell merges them in.
> > 
> > It has worked OK, although Russell had some comments about having hard
> > time keeping track on what he had reviewed already.
> 
> Yes, as I understand it, there was a closed room discussion between
> several folk about how you'd handle sending your next round of patches
> to me.

Yes, this was to coordinate the merge conflicts that we knew were going
to happen.
 
> What you apparantly decided (and I'm saying this from how it appeared
> on the receiving end and sort-of had it confirmed by Kevin in conference)
> is that you'd send a patch set for me to review, I'd review it, and then
> you'd merge it within your git tree into a branch for me.  You'd then do
> the same thing with the next patch set, and so forth.
> 
> Eventually, near the merge window, you sent a pull request for the
> entire lot, by which time I looked at the list of changes and wondered
> whether that encompassed everything you'd asked me to review, or whether
> it contained extra stuff, or whether it was for something quite different,
> or what.

Hmm, well it was what was posted to the list, and I kept piling it up
into for-next as the patchsets got reviewed.
 
> So by separating the review from the merge by weeks or even months, it
> created additional problems.

Yeah this can be a problem as at that point you have to pull or check
the patches again if you don't trust people to send you the stuff that got
posted earlier.

You suggested pulling each set as they get reviewed into some omap branch
in your tree, do you want to try that the next merge window?

What I can easily see happening with this approach is that we end up waiting
1 - 2 weeks between each set before you pull, which can make merging painfully
slow as we may have let's say five 10 patch sets to merge.

Also, what do we do with the sets that you don't have time to review or
don't want to review?

Regards,

Tony
