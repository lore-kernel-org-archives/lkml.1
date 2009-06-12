Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbZFLK1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbZFLK1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761149AbZFLK1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:27:06 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64613 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760918AbZFLK1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:27:05 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18H4K3H/XCdBcct0L2xulVp
Date: Fri, 12 Jun 2009 03:26:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612102640.GA7060@atomide.com>
References: <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611132134.GA11199@atomide.com> <20090611133736.GP795@n2100.arm.linux.org.uk> <20090611140038.GB11199@atomide.com> <20090611140624.GS795@n2100.arm.linux.org.uk> <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre <nico@cam.org> [090611 10:30]:
> On Thu, 11 Jun 2009, Russell King - ARM Linux wrote:
> 
> > On Thu, Jun 11, 2009 at 07:00:39AM -0700, Tony Lindgren wrote:
> > > You suggested pulling each set as they get reviewed into some omap branch
> > > in your tree, do you want to try that the next merge window?
> > 
> > If we're following Alan's suggestion, then as I see it you're entirely
> > responsible for tracking what's in OMAP, getting it into linux-next and
> > (I guess) ultimately sending Linus a pull request for it during the
> > merge window.  I just become someone who can put their oar into reviewing
> > OMAP patches as and when.
> 
> I don't see things exactly that way.
> 
> linux-next is a fully automated "let's dump everything together and see 
> what is going to explode" kind of tree.  There is no patch review except 
> from those who see their code being dammaged by the blast.  And it is 
> automated in the sense that git pull operations are done automatically, 
> even if someone deals with the merge conflicts manually afterwards.  My 
> tree can be pulled into linux-next directly or through your tree, or 
> even through both paths in parallel and git will deal with it just fine.  
> And at the end of the day the linux-next tree is tossed in the garbage 
> bin anyway.
> 
> I think that you, as the ARM maintainer, should continue gathering all 
> the ARM subarchitectures into a coherent ARM tree and arbitrate 
> conflicts when they occur.  You should especially keep a tight control 
> on the very core ARM code.  But everything under arch/arm/mach-* you 
> should let people maintaining those have control of that themselves and 
> free yourself from that responsibility as much as possible.  The current 
> directory structure is quite indicative of where the boundaries are 
> already.  This way, if I make a mess of arch/arm/mach-orion5x/* then you 
> just need to pass the blame straight to me.

This is what I was thinking too.

Tony
