Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbXJDWHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbXJDWHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759686AbXJDWHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:07:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54949
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbXJDWHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:07:19 -0400
Date: Thu, 04 Oct 2007 15:07:18 -0700 (PDT)
Message-Id: <20071004.150718.95506800.davem@davemloft.net>
To: cebbert@redhat.com
Cc: willy@linux.intel.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com,
       suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
From: David Miller <davem@davemloft.net>
In-Reply-To: <47055F84.109@redhat.com>
References: <470554D9.2050505@redhat.com>
	<20071004.141113.08322956.davem@davemloft.net>
	<47055F84.109@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>
Date: Thu, 04 Oct 2007 17:47:48 -0400

> On 10/04/2007 05:11 PM, David Miller wrote:
> > From: Chuck Ebbert <cebbert@redhat.com>
> > Date: Thu, 04 Oct 2007 17:02:17 -0400
> > 
> >> How do you simulate reading 100TB of data spread across 3000 disks,
> >> selecting 10% of it using some criterion, then sorting and
> >> summarizing the result?
> > 
> > You repeatedly read zeros from a smaller disk into the same amount of
> > memory, and sort that as if it were real data instead.
> 
> You've just replaced 3000 concurrent streams of data with a single
> stream.  That won't test the memory allocator's ability to allocate
> memory to many concurrent users very well.

You've kindly removed my "thinking outside of the box" comment.

The point is was not that my specific suggestion would be
perfect, but that if you used your creativity and thought
in similar directions you might find a way to do it.

People are too narrow minded when it comes to these things, and
that's the problem I want to address.
