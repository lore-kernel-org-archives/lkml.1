Return-Path: <linux-kernel-owner+w=401wt.eu-S1764497AbXFAUVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764497AbXFAUVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763052AbXFAUUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:20:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762524AbXFAUUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:20:54 -0400
Message-ID: <46607F96.7060200@redhat.com>
Date: Fri, 01 Jun 2007 16:20:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quiet down swiotlb warnings
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org> <466075D1.8080807@redhat.com> <20070601194734.GJ7217@one.firstfloor.org> <20070601200049.GK12143@andrew-vasquezs-computer.local> <20070601201444.GK7217@one.firstfloor.org>
In-Reply-To: <20070601201444.GK7217@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Jun 01, 2007 at 01:00:49PM -0700, Andrew Vasquez wrote:
>> yes, the card can support 64bit DMA transfers. but in this case the
>> 'required' DMA mask returned from dma_get_required_mask() states that a
>> 32bit mask would suffice.
> 
> That's a bug in the kernel then that needs to be fixed. Find out
> why it does that and change it. Don't fix the symptoms, fix the root cause.

The system in question only has 2GB of memory.

Why would it need to do 64 bit DMA?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
