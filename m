Return-Path: <linux-kernel-owner+w=401wt.eu-S965180AbXDBGwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180AbXDBGwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964935AbXDBGwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:52:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:55436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966AbXDBGwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rj7RB1TiFBCB1agERcuso8EDOUR7WlfVkC4zHnl65aOdf2EfCA0c9NYqmhl6ixS4UsKDfEM/zdcfPc657Owg5g1j0LgojzrzaGEqaca2zc7glQVejm6WZcWikR2ZLWKMlvB6zbDUiDRRQCfMpJmtADZDyrlzgGR5CotRtR/cuSI=
Message-ID: <21d7e9970704012352t277a6cadx259172641531fc39@mail.gmail.com>
Date: Mon, 2 Apr 2007 16:52:04 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20070402064046.GA24269@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
	 <20070401.201134.82699692.davem@davemloft.net>
	 <21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
	 <20070401.220841.89389711.davem@davemloft.net>
	 <21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com>
	 <p731wj31ear.fsf@bingen.suse.de>
	 <21d7e9970704012238x2c5e6c62hc30933d9575910cf@mail.gmail.com>
	 <20070402064046.GA24269@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> > need, this just seems overly cumbersome when what I really want is
> > vmalloc_32 to just work correctly on 64-bit systems... (why doesn't
> > vmalloc_32 pass __GFP_DMA32 to the allocator????)
>
> It probably should, but see second part of sentence above.
>
> And please never put closed lists in cc of l-k posts. Evil cc dropped.

Ah okay I'll just do an allocator based on single pages and see if I
can fix the kernel side to have the sg knowledge....

btw Its not a closed list, it's is a moderated list, all the posts do
get through to it and the people on it are probably interested...

Dave.
