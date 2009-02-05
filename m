Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZBEVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZBEVIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZBEVIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:08:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:49197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZBEVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:08:04 -0500
Subject: Re: [PATCH 08/16] dma-debug: add core checking functions
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       davem@davemloft.net
In-Reply-To: <1232376423-11067-9-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
	 <1232376423-11067-9-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 21:07:59 +0000
Message-Id: <1233868079.3548.699.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 15:46 +0100, Joerg Roedel wrote:
>  
> +       if (ref->type != entry->type) {
> +               err_printk(ref->dev, "DMA-API: device driver frees "
> +                          "DMA memory with wrong function "
> +                          "[device address=0x%016llx] [size=%llu bytes] "
> +                          "[mapped as %s] [unmapped as %s]\n",
> +                          ref->dev_addr, ref->size,
> +                          type2name[entry->type], type2name[ref->type]);

e1000e 0000:00:19.0: DMA-API: device driver frees DMA memory with wrong
function [device address=0x00000000ffedc002] [size=90 bytes] [mapped as
single] [unmapped as page]


<davem> That debug check is excessive, substituting those two things
works for every DMA API implementation I am aware of

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

