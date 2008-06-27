Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbYF0Rpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbYF0Rpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYF0RpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:45:20 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:1370 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbYF0RpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:45:19 -0400
Date: Fri, 27 Jun 2008 13:44:15 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com,
       Ben-Ami Yassour1 <BENAMI@il.ibm.com>
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080627174415.GF26130@il.ibm.com>
References: <20080627142558.GG18644@cs181140183.pp.htv.fi> <878wwrq6im.fsf@basil.nowhere.org> <20080627163945.GA26130@il.ibm.com> <20080627165430.GD10197@8bytes.org> <20080627165947.GB26130@il.ibm.com> <20080627170546.GE10197@8bytes.org> <20080627171201.GC26130@il.ibm.com> <20080627172030.GF10197@8bytes.org> <20080627173100.GD26130@il.ibm.com> <20080627174034.GG10197@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627174034.GG10197@8bytes.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 07:40:35PM +0200, Joerg Roedel wrote:

> Yes. As I said, this is for the non-isolating case. For the
> isolation case (which is needed for protection) it is harder to
> optimize. But there I think about some sort of lazy IOMMU TLB
> flushing. The flushing and 'wait for the flush to finish' is the
> most expensive part in the mapping and unmapping code path. But this
> needs some experiments.

Agreed. The paper I just posted to the iommu mailing list has some
ideas and experimental data.

> > I am thinking of them and I'd be surprised if you'd find any in
> > such machines. Certainly I assume none of the on-board devices
> > will have this ancient limitation. But hey, it could happen ;-)
> 
> The IOMMU machine under my desk has a 32bit PCI slot with a card in
> it :-)

Touche :-)

Cheers,
Muli
