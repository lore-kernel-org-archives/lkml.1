Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbXK0WcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbXK0WcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbXK0WcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:32:05 -0500
Received: from panic.printk.net ([217.147.83.20]:38595 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXK0WcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:32:04 -0500
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <200711271549.37670.rusty@rustcorp.com.au>
References: <20071122343.446909000@suse.de>
	 <200711261228.15155.rusty@rustcorp.com.au> <adahcj9sfan.fsf@cisco.com>
	 <200711271549.37670.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 27 Nov 2007 17:31:38 -0500
Message-Id: <1196202698.3415.119.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 15:49 +1100, Rusty Russell wrote:
> On Monday 26 November 2007 17:15:44 Roland Dreier wrote:

> > It seems pretty   
> > clear to me that having a mechanism that requires modules to make
> > explicit which (semi-)internal APIs makes reviewing easier
> 
> Perhaps you've got lots of patches were people are using internal APIs they 
> shouldn't?

With my "Enterprise" hat on, I can see where Andi was coming from
originally. Just like we do in RHEL, SuSE have a concept of a kernel ABI
and we too have a concept of a whitelist of symbols - a subset of kernel
ABI that is approved for use by third parties (this is nothing to do
with licensing, this is to do with ABI stability we try to ensure).

As part of figuring out what should and should not be used by external
modules (outside of the core kernel), we've gained a bit of experience,
and it would be nice to be able to help others - this is nothing to do
with upstream "ABI stability", but just to be of a public service by
documenting those functions that are never intended for modules but
which necessarily are exported because they have one or two users.

> > , makes it 
> > easier to communicate "please don't use that API" to module authors,
> 
> Well, introduce an EXPORT_SYMBOL_INTERNAL().  It's a lot less code.  But you'd 
> still need to show that people are having trouble knowing what APIs to use.

I suggested this exact idea privately at OLS. I still think it's the
best compromise, though I like bits of the namespace idea. An
EXPORT_SYMBOL_INTERNAL would indeed be trivial.

Jon.


