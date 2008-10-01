Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYJANxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYJANxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 09:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYJANxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 09:53:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:60718 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYJANxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 09:53:21 -0400
Date: Wed, 1 Oct 2008 06:53:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>, Kyle McMartin <kyle@mcmartin.ca>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20081001065305.647715b3@infradead.org>
In-Reply-To: <20081001130717.GE10632@phobos.i.cabal.ca>
References: <20080926163641.288bf868@infradead.org>
	<20080926163718.32f0867e@infradead.org>
	<20080929072643.GA28871@colo.lackof.org>
	<20080929064220.374c68a4@infradead.org>
	<20080929171049.GA14409@colo.lackof.org>
	<20080929102325.0ca5c0c9@infradead.org>
	<20081001052450.GB7348@colo.lackof.org>
	<20080930153001.1107c0de@infradead.org>
	<20081001124254.GD10632@phobos.i.cabal.ca>
	<20081001125711.GG13822@parisc-linux.org>
	<20081001130717.GE10632@phobos.i.cabal.ca>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 09:07:17 -0400
Kyle McMartin <kyle@mcmartin.ca> wrote:
> > 
> > OK, not all architectures use the generic code, but I've been
> > through and they all do more or less the above (mn10300 and frv
> > just return the address, but their readl() and inl() are identical)
> > 
> 
> I don't recall anyone ever promising that the iomap interfaces would
> be usable with legacy accessors. I'd certainly prefer it if we
> didn't, as well, as it makes for more explicitly written drivers...
> 
> Just because you can use them, doesn't mean you should.
> 

ok so now we're full circle.
I started with a real ioremap, was told "no must use iomap" despite the
same argument you make, and now we're back to square one.

What I want is an interface that can replace ioremap() for the common
"I want the bar uncached" case. Nothing more nothing less.... sigh.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
