Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZAISRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZAISRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZAISRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:17:33 -0500
Received: from 8bytes.org ([88.198.83.132]:52464 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbZAISRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:17:32 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 13:17:32 EST
Date: Fri, 9 Jan 2009 19:17:31 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: [PATCH 05/16] dma-debug: add initialization code
Message-ID: <20090109181731.GC9466@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-6-git-send-email-joerg.roedel@amd.com> <20090109175842.GC30168@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109175842.GC30168@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 08:58:42PM +0300, Evgeniy Polyakov wrote:
> On Fri, Jan 09, 2009 at 05:19:19PM +0100, Joerg Roedel (joerg.roedel@amd.com) wrote:
>  +static int prealloc_memory(u32 num_entries)
> > +{
> > +	struct dma_debug_entry *entry, *next_entry;
> > +	int i;
> > +
> > +	for (i = 0; i < num_entries; ++i) {
> > +		entry = kmalloc(sizeof(*entry), GFP_KERNEL | __GFP_ZERO);
> 
> kzalloc?

True. kzalloc is better. I will change that.

Joerg
