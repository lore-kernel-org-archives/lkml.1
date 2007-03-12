Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbXCLW00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbXCLW00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXCLW00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:26:26 -0400
Received: from ozlabs.org ([203.10.76.45]:37662 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960AbXCLW0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:26:25 -0400
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@muc.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45F5604E.5020400@s5r6.in-berlin.de>
References: <1173655694.32234.213.camel@localhost.localdomain>
	 <45F51C25.76E4.0078.0@novell.com>
	 <1173691510.32234.222.camel@localhost.localdomain>
	 <45F53C4D.30802@s5r6.in-berlin.de>
	 <Pine.LNX.4.64.0703120748310.6942@CPE00045a9c397f-CM001225dbafb6>
	 <45F5604E.5020400@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 09:25:03 +1100
Message-Id: <1173738303.10618.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 15:14 +0100, Stefan Richter wrote:
> Robert P. J. Day wrote:
> > On Mon, 12 Mar 2007, Stefan Richter wrote:
> >> Rusty Russell wrote:
> >> > OTOH, BUILD_BUG_OR_ZERO says what happens: either it's a build bug, or
> >> > it's zero.
> >>
> >> What about ZERO_UNLESS_BUILD_BUG_ON(e)? It's long though...
> > 
> > how often is this going to be used?  it's not like the tree is
> > currently awash in calls to BUILD_BUG_ON_ZERO as it is.
> 
> Most of the time it will hidden as a macro-in-a-macro, like in
> ARRAY_SIZE().  So the length of the name doesn't matter much.  But then,
> the _name_ itself doesn't matter much because authors of public macros
> are the primary user group, not John Driverhacker.

Well, there's a four line comment above it, so *someone* thought it
worth documenting.  Even if the new name isn't great, the old name is
actively misleading.  That's a 13, and we could be a 4.

http://ozlabs.org/~rusty/ols-2003-keynote/img52.html

Cheers,
Rusty.


