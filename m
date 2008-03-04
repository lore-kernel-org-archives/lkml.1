Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbYCDRi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbYCDRi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYCDRiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:38:20 -0500
Received: from ns.suse.de ([195.135.220.2]:50317 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYCDRiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:38:19 -0500
Date: Tue, 4 Mar 2008 09:38:40 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Roskin <proski@gnu.org>,
       Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080304173840.GA16165@suse.de>
References: <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu> <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu> <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net> <20080304125744.GF29777@elte.hu> <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 09:19:36AM -0800, Linus Torvalds wrote:
> Quite frankly, my position on this has always been that the GPLv2 
> explicitly covers _derived_ works only, and that very obviously a Windows 
> driver isn't a derived work of the kernel. So as far as I'm concerned, 
> ndiswrapper may be distasteful froma technical and support angle, but not 
> against the license.

I think ndiswrapper is a great hack from a technical point-of-view.  But
yes, I also do not think it is a violation of the GPLv2 for the same
reasons you do.

> So I'm personally perfectly happy to say that we should revert that commit 
> 0aa5bd52d0c49ca56d24584c646e6544ccbb3dc9, but what I've wanted to hear 
> from the very beginning was simply to get a list of symbols that currently 
> clash, and hear from the people who maintain the symbols whether they 
> really meant for that commit to be valid.
> 
> That's the only issue here. Not whether ndiswrapper could do a part of its 
> job in user space (because the answer to that latter question is: no. 
> Everything is "possible", of course, but realistically, that's simply not 
> going to happen).
> 
> It sounds like there aren't that many symbols affected at the core: the 
> workqueue stuff certainly isn't worth bothering about. The USB things that 
> ndiswrapper wants is much more involved, and more likely to have issues, 
> but I'm cc'ing Greg here to see.

I have no objection to reverting that patch to have nidiswrapper access
to those symbols, especially as that is really the only way they will be
able to control USB devices (as you state, doing a network driver in
userspace doesn't really make sense.)

thanks,

greg k-h
