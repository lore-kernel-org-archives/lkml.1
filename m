Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYKJTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYKJTH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 14:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYKJTHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 14:07:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44680 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753231AbYKJTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 14:07:13 -0500
Date: Mon, 10 Nov 2008 13:07:11 -0600
From: Robin Holt <holt@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, "Luck, Tony" <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-ia64@vger.kernel.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
Message-ID: <20081110190711.GG8483@sgi.com>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com> <87d4h3pwhe.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4h3pwhe.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 01:59:57PM +0100, Andi Kleen wrote:
> Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> >   3) A device which allows over 4GB is hot-added.
> >      But dma_alloc_coherent() try to allocate DMA zone.
> >      Then OOM occurs because there is no freeable pages.
> >
> > I heard there are some users who require a few GB mlock.
> 
> Normally mlock is limited to half the memory exactly to avoid
> such problems.
> 
> Also I believe there are some issues with non continuous memory on
> some IA64 systems -- e.g. Altixes iirc have the requirement
> that you use the IOMMU for higher memory. So it's probably
> not easy to change.

I am not sure what is be referred to here, but all of an Altix's memory is
DMA capable with the exception of the stuff covered by the MSPEC driver
(that is uncached memory).  There are certainly all sort of special
requirements for doing transfers on Altix to eliminate memory ordering
problems, but nothing specific that I recall related to address ranges
and DMA.

I appologize in advance if I am answering a different question that
was asked.

Thanks,
Robin
