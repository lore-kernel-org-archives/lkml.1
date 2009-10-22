Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZJVPqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZJVPqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbZJVPqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:46:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:50001 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbZJVPql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:46:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,605,1249282800"; 
   d="scan'208";a="506211989"
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
 failures V2
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
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
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
In-Reply-To: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Thu, 22 Oct 2009 08:43:38 -0700
Message-Id: <1256226219.21134.1493.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 07:22 -0700, Mel Gorman wrote:
> [Bug #14141] order 2 page allocation failures in iwlagn
> 	Commit 4752c93c30441f98f7ed723001b1a5e3e5619829 introduced GFP_ATOMIC
> 	allocations within the wireless driver. This has caused large numbers
> 	of failure reports to occur as reported by Frans Pop. Fixing this
> 	requires changes to the driver if it wants to use GFP_ATOMIC which
> 	is in the hands of Mohamed Abbas and Reinette Chatre. However,
> 	it is very likely that it has being compounded by core mm changes
> 	that this series is aimed at.

Driver has been changed to allocate paged skb for its receive buffers.
This reduces amount of memory needed from order-2 to order-1. This work
is significant and will thus be in 2.6.33. 

Reinette


