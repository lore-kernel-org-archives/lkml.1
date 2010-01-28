Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522Ab0A1U7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0A1U7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705Ab0A1U7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:59:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:46230 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0A1U7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:59:53 -0500
Subject: Re: [PATCH 04/11] VT-d: Change {un}map_range functions to
 implement {un}map interface
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1264678682-30655-5-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
	 <1264678682-30655-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 09:59:42 +1300
Message-ID: <1264712382.9059.1109.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 12:37 +0100, Joerg Roedel wrote:
> This patch changes the iommu-api functions for mapping and
> unmapping page ranges to use the new page-size based
> interface. This allows to remove the range based functions
> later. 

> +       size     = 0x1000UL << gfp_order;

Um, that's not a page-size based interface. Page size isn't always 4KiB;
this code runs on IA64 too.

We have enough fun with CPU vs. DMA page size on IA64 already :)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

