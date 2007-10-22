Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbXJVNxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbXJVNxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXJVNxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:53:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:45563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbXJVNxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:53:40 -0400
To: Or Sagi <ors@tutis.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Nir Peleg <nir@tutis.com>
Subject: Re: [PATCH] Reserve low memory
From: Andi Kleen <andi@firstfloor.org>
References: <20071021165401.GA8626@cleopatra.qumranet.com>
Date: Mon, 22 Oct 2007 15:53:39 +0200
In-Reply-To: <20071021165401.GA8626@cleopatra.qumranet.com> (Or Sagi's message of "Sun\, 21 Oct 2007 18\:54\:01 +0200")
Message-ID: <p73oder9rx8.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Or Sagi <ors@tutis.com> writes:

> Adds a CONFIG_RESERVE_LOWMEM option which reserves all memory below
> CONFIG_PHYSICAL_START address.
>
> Cleans up some of the static early-boot memory allocations (nodemap, trampoline)
> Useful in particular for running virtual machines which require a 1:1 mapping 
> of the physical memory. This lets a virtual machine control a dma-capable device
> directly without hypervisor involvement.

With the infrastructure in 
ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
you can do this much cleaner (and likely safer)

And using CONFIG_* options for such things is wrong anyways. If anything
it should be run time options.

-Andi
>
