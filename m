Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbXFBPVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbXFBPVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 11:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbXFBPVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 11:21:48 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:11826 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbXFBPVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 11:21:47 -0400
Date: Sat, 2 Jun 2007 18:21:46 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070602152146.GE4342@rhun.haifa.ibm.com>
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org> <466075D1.8080807@redhat.com> <20070601194734.GJ7217@one.firstfloor.org> <20070601200049.GK12143@andrew-vasquezs-computer.local> <20070601201444.GK7217@one.firstfloor.org> <46607F96.7060200@redhat.com> <20070601202601.GM7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601202601.GM7217@one.firstfloor.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 10:26:01PM +0200, Andi Kleen wrote:

> Normally swiotlb doesn't even try to bounce when dma mask is <=
> end_pfn so something must be very wrong in your kernel. It
> definitely isn't a mainline kernel. If this happens in Xen then Xen
> just needs fixing -- it should not try to bounce when the normal
> kernel wouldn't.

Xen needs to bounce when the requested buffer is not contiguous in
machine memory (and indeed uses swiotlb for that).

Cheers,
Muli
