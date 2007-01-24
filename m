Return-Path: <linux-kernel-owner+w=401wt.eu-S965477AbXAXAuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477AbXAXAuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965603AbXAXAuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:50:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:37127 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965475AbXAXAuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:50:22 -0500
Subject: Re: [RFC] pci_bus conversion to struct device
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tim Pepper <lnxninja@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, Martin Mares <mj@ucw.cz>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <eada2a070701231622w73858129i3319f66fa83a31c1@mail.gmail.com>
References: <20070118005344.GA8391@kroah.com>
	 <20070118022352.GA17531@parisc-linux.org>
	 <mj+md-20070118.081204.18154.nikam@ucw.cz>
	 <20070118090044.GA23596@kroah.com>
	 <eada2a070701231622w73858129i3319f66fa83a31c1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 11:47:44 +1100
Message-Id: <1169599664.18754.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 16:22 -0800, Tim Pepper wrote:
> On 1/18/07, Greg KH <greg@kroah.com> wrote:
> 
> > Hm, only ia64 enables that option.  Matthew, do you care about those
> > files?
> 
> Given the ia64 nature, unless benh was truly wanting to do something
> or ppc64, IBM's big NUMA boxes are pretty unlikely to care.

I'd still like to do something at one point for ppc and ppc64... or
others. It's a generic problem with non-x86 machines.

In addition, there is the problem of legacy VGA arbitration

Part of the problem with legacy VGA accesses is also that it needs some
level of arbitration which we currently don't do in the kernel at all. X
does some stuff, but it doesn't necessarily arbitrate well with other
things for obvious reasons :-)

I wrote some code for that a little while ago but never quite finished,
and X would have had to be ported over. I might give it a go again one
of these days though. Now that X is slowly moving over some sane PCI
access library, there is a good opportunity to slap in support for a
nice kernel based VGA access arbitration interface.

Ben.


