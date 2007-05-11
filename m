Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbXEKS54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbXEKS54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXEKS5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:57:49 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3564 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbXEKS5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:57:48 -0400
Date: Fri, 11 May 2007 19:57:36 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, cw@f00f.org,
       linux-kernel@vger.kernel.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070511185736.GG26112@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	David Miller <davem@davemloft.net>, cw@f00f.org,
	linux-kernel@vger.kernel.org
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk> <20070511185431.GA31719@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511185431.GA31719@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 08:54:31PM +0200, Sam Ravnborg wrote:
> On Thu, May 10, 2007 at 09:54:27PM +0100, Russell King wrote:
> > On Thu, May 10, 2007 at 01:51:47PM -0700, David Miller wrote:
> > > From: Chris Wedgwood <cw@f00f.org>
> > > Date: Thu, 10 May 2007 13:34:18 -0700
> > > 
> > > > MODPOST seems to be spewing bogus warnings.  It's not clear how best
> > > > to fix it so perhaps we should silence it for now?
> > > 
> > > Most of them are legitimate, the only one that needs sorting
> > > is the mm/slab.c case and people are working on that.
> > > 
> > > The rest are useful and I've been working to fix things up
> > > on sparc64 and the networking, and in fact I'm very happy
> > > about these notifications.
> > > 
> > > Please don't apply a sledgehammer to this issue, thanks.
> > 
> > I've not had one accurate one on ARM yet.
> 
> To be able to test my modpost changes I am building arm for all configs.
> I can see a number of legitime warnings for the ARM code.
> Those I have investigated has all been of the case where functions
> are used only during init but not marked init.
> So no real bugs just potential savings and consistency.
> Shall I try to fix them up and drop you a path?

It'll probably be worth doing this after -rc1 - there's still some
stuff in flux at the moment.

However, note that my comments above were based on a mis-understanding
of the warnings.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
