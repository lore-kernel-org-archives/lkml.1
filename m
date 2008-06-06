Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbYFFUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbYFFUXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbYFFUXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:23:34 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:43141 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYFFUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:23:33 -0400
Date: Fri, 6 Jun 2008 23:23:24 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: grundler@google.com, linux-kernel@vger.kernel.org, mgross@linux.intel.com,
       linux-scsi@vger.kernel.org
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Message-ID: <20080606202324.GR15085@il.ibm.com>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp> <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com> <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 11:49:12PM +0900, FUJITA Tomonori wrote:

> > I didn't check....but reserving MMIO address space might be better
> > done by looking at MMIO ranges routed by all the top level PCI
> > Host-bus controllers (aka PCI-e Root ports). Maybe this is an idea
> > for Mark Gross to implement.
> 
> Calgary IOMMU code does the similar stuff, but I'm not sure. Anyway,
> as you said, it's about what Mark might be interested in.

I'm not sure it's strictly necessary, but we observed Bad Things(TM)
happening when we gave out DMA addresses that corresponded to MMIO
regions and black-listing those regions seemed the safest thing to do.

Cheers,
Muli
