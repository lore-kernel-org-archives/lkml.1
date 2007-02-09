Return-Path: <linux-kernel-owner+w=401wt.eu-S1946472AbXBIORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946472AbXBIORN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946474AbXBIORN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:17:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45704 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946472AbXBIORM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:17:12 -0500
Date: Fri, 9 Feb 2007 15:17:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@muc.de>, virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
Message-ID: <20070209141728.GA26749@uranus.ravnborg.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012761.2718.40.camel@localhost.localdomain> <1171012827.2718.42.camel@localhost.localdomain> <200702091109.20061.ak@muc.de> <1171024771.2718.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171024771.2718.129.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 11:39:31PM +1100, Rusty Russell wrote:
> On Fri, 2007-02-09 at 11:09 +0100, Andi Kleen wrote:
> > On Friday 09 February 2007 10:20, Rusty Russell wrote:
> > > Unfortunately, we don't have the build infrastructure for "private"
> > > asm-offsets.h files, so there's a not-so-neat include in
> > > arch/i386/kernel/asm-offsets.c.
> > 
> > Ask the kbuild people to fix that? 
> > 
> > It indeed looks ugly.
> > 
> > I bet Xen et.al. could make good use of that too.
> 
> Yes.   I originally had the constants #defined in the header and a whole
> heap of BUILD_BUG_ON(XYZ_offset != offsetof(xyz)) in my module, which
> was even uglier (but at least contained in my code).
I do not quite see what you ask for.
Care to try to describe the problem a bit then I may look at it sometime.

[Heading for vacation in a few hours so no prompt reply]

	Sam
