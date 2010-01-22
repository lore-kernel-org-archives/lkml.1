Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827Ab0AVDup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab0AVDup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449Ab0AVDuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:50:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:42720 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab0AVDuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:50:44 -0500
Subject: Re: [CFT] MM: Pass a PTE pointer to update_mmu_cache() rather than
 the PTE itself
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100120135202.GA20937@flint.arm.linux.org.uk>
References: <20100120135202.GA20937@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 14:50:19 +1100
Message-ID: <1264132219.3601.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 13:52 +0000, Russell King wrote:
> On VIVT ARM, when we have multiple shared mappings of the same file
> in the same MM, we need to ensure that we have coherency across all
> copies.  We do this via make_coherent() by making the pages
> uncacheable.
> 
> This used to work fine, until we allowed highmem with highpte - we
> now have a page table which is mapped as required, and is not available
> for modification via update_mmu_cache().

Looks good. I'll test when I'm back from LCA.

Cheers,
Ben.


