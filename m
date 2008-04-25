Return-Path: <linux-kernel-owner+w=401wt.eu-S1765792AbYDYUp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765792AbYDYUp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYDYUpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:45:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59568 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbYDYUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:45:10 -0400
Date: Fri, 25 Apr 2008 21:44:50 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Paul Walmsley <paul@pwsan.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       David Brownell <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080425204450.GC28893@flint.arm.linux.org.uk>
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com> <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com> <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com> <20080425103942.GC14903@elf.ucw.cz> <20080425202010.GA28893@flint.arm.linux.org.uk> <bc64b4640804251334j7e2fbf30u358e010bc3e5d5ec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804251334j7e2fbf30u358e010bc3e5d5ec@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 12:34:55AM +0400, Dmitry wrote:
> Hi,
> 
> 2008/4/26, Russell King <rmk+lkml@arm.linux.org.uk>:
> > On Fri, Apr 25, 2008 at 12:39:42PM +0200, Pavel Machek wrote:
> >  > WTF? There are currently around 10 copies of clock code in the tree,
> >  > every one slightly different. If this can help us get rid of all that
> >  > crap, that's a GOOD THING, normative or not.
> >
> >
> > At the expense of people going off and inventing their own APIs because
> >  they find that the "normatived" clock API doesn't do what they need to?
> 
> Why? We do already have the API. And it's pretty normative. And the
> goal of my framework is to allow me and few other people not to
> reinvent the API for non-platform clocks.
> 
> >  That's what will happen if you try to force a framework on folk which
> >  they don't agree with.
> 
> If you don't want to use it, you are free to do so. E.g. you can use
> your own set of functions to implement GPIO api.

Now go back and read what Pavel wrote (which I responsed to - the
implication that your clock API _will_ _be_ forced upon _everyone_) and
you'll see that he has a completely different perspective to what you've
just said.  So rather than replying to my response, why not respond to
Pavel with your points you've made above?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
