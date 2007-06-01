Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbXFAUOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbXFAUOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762790AbXFAUOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:14:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762294AbXFAUOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:14:46 -0400
Date: Fri, 1 Jun 2007 22:14:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070601201444.GK7217@one.firstfloor.org>
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org> <466075D1.8080807@redhat.com> <20070601194734.GJ7217@one.firstfloor.org> <20070601200049.GK12143@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601200049.GK12143@andrew-vasquezs-computer.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 01:00:49PM -0700, Andrew Vasquez wrote:
> yes, the card can support 64bit DMA transfers. but in this case the
> 'required' DMA mask returned from dma_get_required_mask() states that a
> 32bit mask would suffice.

That's a bug in the kernel then that needs to be fixed. Find out
why it does that and change it. Don't fix the symptoms, fix the root cause.

-Andi
