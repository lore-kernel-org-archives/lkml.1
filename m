Return-Path: <linux-kernel-owner+w=401wt.eu-S965744AbXCLLwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744AbXCLLwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXCLLwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:52:51 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57078 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965744AbXCLLwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:52:49 -0400
X-Originating-Ip: 74.109.98.130
Date: Mon, 12 Mar 2007 07:49:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
In-Reply-To: <45F53C4D.30802@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0703120748310.6942@CPE00045a9c397f-CM001225dbafb6>
References: <1173655694.32234.213.camel@localhost.localdomain> 
 <45F51C25.76E4.0078.0@novell.com> <1173691510.32234.222.camel@localhost.localdomain>
 <45F53C4D.30802@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Stefan Richter wrote:

> Rusty Russell wrote:
> > On Mon, 2007-03-12 at 08:23 +0000, Jan Beulich wrote:
> >> I have to admit that I don't see the point here - I can't seem to make
> >> any sense of the OR... Jan
> >
> > At least one other person thought that:
> >
> > 	#define BUILD_BUG_ON_ZERO(e) BUILD_BUG_ON((e) == 0)
> >
> > OTOH, BUILD_BUG_OR_ZERO says what happens: either it's a build bug, or
> > it's zero.
>
> What about ZERO_UNLESS_BUILD_BUG_ON(e)? It's long though...

how often is this going to be used?  it's not like the tree is
currently awash in calls to BUILD_BUG_ON_ZERO as it is.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
