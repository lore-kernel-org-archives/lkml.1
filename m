Return-Path: <linux-kernel-owner+w=401wt.eu-S965618AbXAZMXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbXAZMXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 07:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965619AbXAZMXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 07:23:41 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:38100 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965618AbXAZMXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 07:23:40 -0500
Date: Fri, 26 Jan 2007 13:23:39 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Intel PCI-E bridge ACPI resources and possibly related SATA
 unstability problems on ASUS A8Js
In-Reply-To: <20070125135813.GB9917@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0701261320260.6213@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz>
 <E1HA1Se-0002Y3-VQ@flower> <Pine.LNX.4.64.0701251325250.20484@kepler.fjfi.cvut.cz>
 <20070125135813.GB9917@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Oleg Verych wrote:

> On Thu, Jan 25, 2007 at 01:28:56PM +0100, Martin Drab wrote:
> > On Thu, 25 Jan 2007, Oleg Verych wrote:
> > 
> > > gmane.linux.kernel:
> > > > recently I got my hands on an ASUS A8Js notebook (Core 2 Duo T7200,
> > > > Intel 945 PM PCI-E Chipset, for details see attached log). After booting 
> > > > the latest 2.6.20-rc5-git3 kernel (but the same behaviour occurs also with 
> > > > the 2.6.19.2, didn't try any other), some strange behaviour can be 
> > > > observed.
> > > 
> > > There were disscussions about mmconfig and what nightmare it brought to
> > > PCI(E) configuration in scope of BIOS, chip bugs. Here's (one of) such:
> > > <http://marc.theaimsgroup.com/?l=linux-kernel&m=116007091004503&w=2>
> > > 
> > > > At first the following messages appear in the log:
> > > >
> > > > ...
>       [   40.303154] PCI: BIOS *Bug*: MCFG area at e0000000 is not E820-reserved
> > > > [   40.303157] PCI: Not using MMCONFIG.
> > > >
> > > > (not sure whether this is really a problem)
> > > 
> > > I think it may be the major problem.
> > 
> > Hmm, it may be. Was there suggested any solution (or at least proposal) 
> > that I may try?
> 
> Try fix BIOS bugs: <http://permalink.gmane.org/gmane.linux.kernel/462632>

ASUS refused to help fixing the BIOS with words that ASUS notebooks do not 
support Linux. So if we do not workaround this somehow, Linux would really 
be unusable on this HW. :(

Martin
