Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbXK0XG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbXK0XG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbXK0XGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:06:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXK0XGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:06:46 -0500
Date: Wed, 28 Nov 2007 00:06:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071127230645.GB31491@one.firstfloor.org>
References: <20071122343.446909000@suse.de> <200711261228.15155.rusty@rustcorp.com.au> <adahcj9sfan.fsf@cisco.com> <200711271549.37670.rusty@rustcorp.com.au> <1196202698.3415.119.camel@jcmlaptop> <20071127223743.GI24223@one.firstfloor.org> <20071127150022.61bdff7e@freepuppy.rosehill>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127150022.61bdff7e@freepuppy.rosehill>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 03:00:22PM -0800, Stephen Hemminger wrote:
> On Tue, 27 Nov 2007 23:37:43 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > With my "Enterprise" hat on, I can see where Andi was coming from
> > > originally. 
> > 
> > For the record my original motivation was to fix the "TCP exports everything
> > for ipv6.ko" case cleanly. I later realized that it would be useful for the
> > ABI stability issues too, but it was really not my primary motivation.
> > This is why I didn't even mention that in the original patch description.
> 
> Since ipv6 can never be removed because it references itself, the whole concept

AFAIK that is obsolete anyways. It was done because it was feared it would
be broken, but at least the broken cases I knew about were all fixed
a long time ago. Most likely it could be safely removed.

> of a modular ipv6 is flawed. 

Modules that cannot be unloaded are still useful. Standard case: Distributions
like to offer an option to not use ipv6 because that is popular workaround
for the common "DNS server eats AAAA queries and causes delays" issue.
Forcing the user to rebuild the kernel for this wouldn't be practical.
If ipv6 wasn't modular that would be hard to do.

-Andi
