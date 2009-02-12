Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbZBLOtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbZBLOtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZBLOta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:49:30 -0500
Received: from 8bytes.org ([88.198.83.132]:37030 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbZBLOta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:49:30 -0500
Date: Thu, 12 Feb 2009 15:49:29 +0100
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 08/16] dma-debug: add core checking functions
Message-ID: <20090212144928.GB2125@8bytes.org>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com> <1232376423-11067-9-git-send-email-joerg.roedel@amd.com> <1233868079.3548.699.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233868079.3548.699.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 09:07:59PM +0000, David Woodhouse wrote:
> On Mon, 2009-01-19 at 15:46 +0100, Joerg Roedel wrote:
> >  
> > +       if (ref->type != entry->type) {
> > +               err_printk(ref->dev, "DMA-API: device driver frees "
> > +                          "DMA memory with wrong function "
> > +                          "[device address=0x%016llx] [size=%llu bytes] "
> > +                          "[mapped as %s] [unmapped as %s]\n",
> > +                          ref->dev_addr, ref->size,
> > +                          type2name[entry->type], type2name[ref->type]);
> 
> e1000e 0000:00:19.0: DMA-API: device driver frees DMA memory with wrong
> function [device address=0x00000000ffedc002] [size=90 bytes] [mapped as
> single] [unmapped as page]
> 
> 
> <davem> That debug check is excessive, substituting those two things
> works for every DMA API implementation I am aware of

True. Buts it is an API violation, isn't it?

Joerg

