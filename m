Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZJ0KkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZJ0KkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZJ0KkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:40:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33136 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbZJ0KkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:40:17 -0400
Date: Tue, 27 Oct 2009 10:40:17 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, Kalle Valo <kalle.valo@iki.fi>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
	failures V2
Message-ID: <20091027104017.GC8900@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256226219.21134.1493.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1256226219.21134.1493.camel@rc-desk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 08:43:38AM -0700, reinette chatre wrote:
> On Thu, 2009-10-22 at 07:22 -0700, Mel Gorman wrote:
> > [Bug #14141] order 2 page allocation failures in iwlagn
> > 	Commit 4752c93c30441f98f7ed723001b1a5e3e5619829 introduced GFP_ATOMIC
> > 	allocations within the wireless driver. This has caused large numbers
> > 	of failure reports to occur as reported by Frans Pop. Fixing this
> > 	requires changes to the driver if it wants to use GFP_ATOMIC which
> > 	is in the hands of Mohamed Abbas and Reinette Chatre. However,
> > 	it is very likely that it has being compounded by core mm changes
> > 	that this series is aimed at.
> 
> Driver has been changed to allocate paged skb for its receive buffers.
> This reduces amount of memory needed from order-2 to order-1. This work
> is significant and will thus be in 2.6.33. 
> 

What do you want to do for -stable in 2.6.31?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
