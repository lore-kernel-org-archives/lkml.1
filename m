Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXGKI4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXGKI4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXGKI4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:56:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55175 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbXGKI4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:56:23 -0400
Date: Wed, 11 Jul 2007 09:55:39 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave McCracken <dave.mccracken@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@skynet.ie>,
       Andrew Morton <akpm@linux-foundation.org>, kenchen@google.com,
       jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
Message-ID: <20070711085539.GA18038@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave McCracken <dave.mccracken@oracle.com>,
	Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@skynet.ie>,
	Andrew Morton <akpm@linux-foundation.org>, kenchen@google.com,
	jschopp@austin.ibm.com, apw@shadowen.org,
	kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
	y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070710102043.GA20303@skynet.ie> <200707100929.46153.dave.mccracken@oracle.com> <20070710152355.GI8779@wotan.suse.de> <200707101211.46003.dave.mccracken@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707101211.46003.dave.mccracken@oracle.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 12:11:45PM -0500, Dave McCracken wrote:
> Ok, maybe disaster is too strong a word.  But any kind of order>0 allocation 
> still has to be approached with fear and caution, with a well tested fallback 
> in the case of the inevitable failures.  How many driver writers would have 
> benefited from using order>0 pages, but turned aside to other less optimal 
> solutions due to their unreliability?  We don't know, and probably never 
> will.  Those people have moved on and won't revisit that design decision.

If you look at almost any other OS they use high-order pages quite a lot.
At least Solaris, IRIX and UnixWare do.

Also not that once we have a high-order pagecache it gives a nice way
to simply reclaim a high-order page directly :)

