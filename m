Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZJXNvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZJXNvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 09:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZJXNvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 09:51:07 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:59599 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647AbZJXNvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 09:51:06 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC failures V2
Date: Sat, 24 Oct 2009 15:51:02 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910241551.08291.elendil@planet.nl>
X-OriginalArrivalTime: 24 Oct 2009 13:51:08.0461 (UTC) FILETIME=[09D885D0:01CA54B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 October 2009, Mel Gorman wrote:
> Since 2.6.31-rc1, there have been an increasing number of GFP_ATOMIC
> failures. A significant number of these have been high-order GFP_ATOMIC
> failures and while they are generally brushed away, there has been a
> large increase in them recently and there are a number of possible areas
> the problem could be in - core vm, page writeback and a specific driver.

I needed a break and have thus been off-line for a few days. Good to see 
there's been progress. I'll try to do some testing tomorrow.

Cheers,
FJP
