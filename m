Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZAKIAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZAKIAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZAKIAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:00:21 -0500
Received: from 8bytes.org ([88.198.83.132]:38444 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZAKIAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:00:20 -0500
Date: Sun, 11 Jan 2009 09:00:19 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: [PATCH 14/16] dma-debug: add checks for sync_single_sg_*
Message-ID: <20090111080019.GK9466@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-15-git-send-email-joerg.roedel@amd.com> <20090110234641.GB20843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110234641.GB20843@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:46:41AM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +void debug_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
> > +			   int nelems, int direction)
> > +{
> > +	struct scatterlist *s;
> > +	int i;
> > +
> > +	if (global_disable)
> > +		return;
> 
> "if (unlikely(global_disable))" i suspect?

True. I  will add unlikely() to all global_disable checks.

Joerg
