Return-Path: <linux-kernel-owner+w=401wt.eu-S1765055AbXHVQcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765055AbXHVQcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbXHVQb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:31:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652AbXHVQbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:31:55 -0400
Date: Wed, 22 Aug 2007 19:25:41 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andi Kleen <ak@suse.de>, linux-ia64@vger.kernel.org,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Message-ID: <20070822172541.GA8058@bingen.suse.de>
References: <46CC48FD.4000607@linux.vnet.ibm.com> <20070822091959.aa38fd3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822091959.aa38fd3e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > [   20.880366] DMA: Out of SW-IOMMU space for 263200 bytes at device ?
> > [   20.886858] Kernel panic - not syncing: DMA: Memory would be corrupted
> 
> Gad, never seen that before.  Andi, Tony: help?

Either the driver is leaking or more likely something went 
wrong with the swiotlb initialization. Earlier boot messages
might tell

-Andi
