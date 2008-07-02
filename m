Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbYGBIh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbYGBIh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYGBIhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:37:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53364 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751048AbYGBIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:37:10 -0400
Date: Wed, 2 Jul 2008 09:12:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Amit Shah <amit.shah@qumranet.com>
Cc: iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Adrian Bunk <bunk@kernel.org>,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       Ben-Ami Yassour1 <benami@il.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Sebastian.Biemueller@amd.com, tglx@linutronix.de, mingo@redhat.com,
       bhavna.sarathy@amd.com
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080702091220.2f367bee@lxorguk.ukuu.org.uk>
In-Reply-To: <200807021115.18242.amit.shah@qumranet.com>
References: <1214508490-29683-2-git-send-email-joerg.roedel@amd.com>
	<20080627173100.GD26130@il.ibm.com>
	<20080627174034.GG10197@8bytes.org>
	<200807021115.18242.amit.shah@qumranet.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Think of 32bit PCI devices in a host with more than 4GB memory :)
> > >
> > > I am thinking of them and I'd be surprised if you'd find any in such
> > > machines. Certainly I assume none of the on-board devices will have
> > > this ancient limitation. But hey, it could happen ;-)
> >
> > The IOMMU machine under my desk has a 32bit PCI slot with a card in it
> 
> Also, remember the "odd-ball devices" we had in our "why is PCI passthrough 
> needed" slide? People might want to upgrade to newer servers and still retain 
> their old PCI devices and assign them to guests.

Nothing odd ball at all.

All SFF ATA controllers are 32bit (thats the PATA port on most PCs
still), even the Intel ICH controllers are 32bit in SFF mode (which is
still how most PCs come with it configured). Most PC hardware is still
32bit. A few bits are 31 or 28 bit just to ruin the party - 31bit being
quite common as old Windows had a 2/2GB split.
