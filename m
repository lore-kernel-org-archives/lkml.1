Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYGXW3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYGXW3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYGXW3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:29:17 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44470 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYGXW3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:29:16 -0400
Date: Thu, 24 Jul 2008 16:29:14 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080724222914.GG5307@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807241506.58973.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Thursday, July 24, 2008 2:51 pm Pierre Ossman wrote:
> > On Thu, 24 Jul 2008 14:07:18 -0700
> >
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > On Thursday, July 24, 2008 1:39 pm Pierre Ossman wrote:
> > > > This is a laptop with a single expressport that worked
> > > > fine up until this merge window. What changed and why is
> > > > it no longer possible to support this hardware without a
> > > > kernel parameter?
> > >
> > > Yeah we're being a bit more careful about registering
> > > hotplug slots these days.  The fact that you got a conflict
> > > message indicates that more than one driver is trying to
> > > bind to that PCIe port and handle hotplug for it.  I guess
> > > acpiphp must already be loaded?
> >
> > Nope. Only pciehp is builtin, and acpiphp is not loaded.
> > Anything non-hotplug related that can block stuff?
> 
> Theoretically only one of the other hotplug drivers could claim
> the slot (e.g.  acpi, cpci, cpqhp, fakephp etc.).  You could
> put a dump_stack() or something into
> drivers/pci/hotplug/pci_hotplug_core.c:pci_hp_register to see
> if we're getting multiple callers on the same slot for some
> reason...  Maybe the pciehp driver itself is trying to register
> the same slot twice?

This is a good idea.

Any chance you could get that debug info for us, Pierre?

Thanks.

/ac

