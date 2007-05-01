Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXEAQna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXEAQna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbXEAQn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:43:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbXEAQn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:43:29 -0400
Message-ID: <46376D97.3040603@redhat.com>
Date: Tue, 01 May 2007 12:40:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
       gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, hch@infradead.org, jengelh@linux01.gwdg.de,
       zwane@infradead.org, neilb@suse.de, jens.axboe@oracle.com,
       eric@provenscaling.com
Subject: Re: [3/3] use vmalloc() to arrange guard pages for stacks
References: <20070430232351.GG26598@holomorphy.com> <20070430233309.GH26598@holomorphy.com> <20070430233712.GI26598@holomorphy.com> <20070430234030.GJ26598@holomorphy.com> <463757A3.7010808@redhat.com> <20070501163140.GM26598@holomorphy.com>
In-Reply-To: <20070501163140.GM26598@holomorphy.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> 
> It's a shame that the resource scalability implications of vmallocspace
> allocations prevent this from being useful in production. One could, in
> principle, establish guard pages within ZONE_NORMAL, but for 4KB stacks
> it's somewhat awkward to dredge up 3 contigous pages, and 4 defeats the
> purpose. Alignment with 8KB stacks wants 2 contiguous order 1 pages that
> span an order 2 page boundary. I guess I could rewrite the page allocator
> (again), but people seem to feel safest with the buddy allocator affairs.
> 
> BTW, did the original patches for this prove to be of any use to you?
> 

No, I never tried them. Seems like I never get to anything these days but
answering bug reports and merging fixes... Putting the feature in-kernel
means I might get to use it though. :)
