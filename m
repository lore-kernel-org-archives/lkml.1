Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbYGBF5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbYGBF5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 01:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYGBF5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 01:57:34 -0400
Received: from mis011.exch011.intermedia.net ([64.78.21.10]:13110 "EHLO
	mis011.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbYGBF5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 01:57:34 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 01:57:34 EDT
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: iommu@lists.linux-foundation.org
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Date: Wed, 2 Jul 2008 11:15:17 +0530
User-Agent: KMail/1.9.9
Cc: Joerg Roedel <joro@8bytes.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Adrian Bunk <bunk@kernel.org>, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, Ben-Ami Yassour1 <benami@il.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Sebastian.Biemueller@amd.com,
       tglx@linutronix.de, mingo@redhat.com, bhavna.sarathy@amd.com
References: <1214508490-29683-2-git-send-email-joerg.roedel@amd.com> <20080627173100.GD26130@il.ibm.com> <20080627174034.GG10197@8bytes.org>
In-Reply-To: <20080627174034.GG10197@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021115.18242.amit.shah@qumranet.com>
X-OriginalArrivalTime: 02 Jul 2008 05:42:23.0539 (UTC) FILETIME=[66F64830:01C8DC06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2008 23:10:35 Joerg Roedel wrote:
> On Fri, Jun 27, 2008 at 01:31:00PM -0400, Muli Ben-Yehuda wrote:

> > > > > and to handle devices with limited DMA address ranges.
> > > >
> > > > I'd be pretty surprised if you'll find such devices on machines which
> > > > will have AMD's IOMMU...
> > >
> > > Think of 32bit PCI devices in a host with more than 4GB memory :)
> >
> > I am thinking of them and I'd be surprised if you'd find any in such
> > machines. Certainly I assume none of the on-board devices will have
> > this ancient limitation. But hey, it could happen ;-)
>
> The IOMMU machine under my desk has a 32bit PCI slot with a card in it

Also, remember the "odd-ball devices" we had in our "why is PCI passthrough 
needed" slide? People might want to upgrade to newer servers and still retain 
their old PCI devices and assign them to guests.

Amit
