Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbXBLH3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbXBLH3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066AbXBLH3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:29:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:48812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbXBLH3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:29:36 -0500
Subject: Re: remote debugging via FireWire
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <ak@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Bernhard Kaindl <bk@suse.de>,
       discuss@x86-64.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200702120749.54976.ak@suse.de>
References: <200702101242.48467.ak@suse.de>
	 <45CE19F3.2070603@s5r6.in-berlin.de>
	 <1171229738.20494.60.camel@localhost.localdomain>
	 <200702120749.54976.ak@suse.de>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 18:29:07 +1100
Message-Id: <1171265347.20494.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 07:49 +0100, Andi Kleen wrote:
> On Sunday 11 February 2007 22:35, Benjamin Herrenschmidt wrote:
> 
> > I'd like to have that on ppc as well, so I'd rather keep it in drivers/
> 
> This will need some abstraction at least -- there are some early mapping hacks
> that are x86 specific right now.

Either abstraction or ifdef's .. we have ioremap working very early on
ppc :-)

> > I agree that it doesn't need to be a module. If you can load modules,
> > then you can load the full ohci driver. Thus, if it's an early thingy
> > initialized by arch, it can export a special "takeover" hook that the
> > proper ohci module can then call to override it (important if we start
> > having an irq handler).
> > 
> > Andi, also, how do you deal with iommu ? Not at all ? :-)
> 
> Yes -- it's really early debugging hack mostly. It's reasonable to 
> let the iommu be disabled (or later a special bypass can be added for this) 

Ok.

Ben.


