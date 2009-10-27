Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbZJ0VAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbZJ0VAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932284AbZJ0VAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:00:08 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:65053 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252AbZJ0VAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:00:04 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/2] page allocator: Direct reclaim should always obey watermarks
Date: Tue, 27 Oct 2009 22:00:04 +0100
User-Agent: KMail/1.9.9
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       reinette chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <1255689446-3858-1-git-send-email-mel@csn.ul.ie> <20091016223237.GE32397@csn.ul.ie> <200910170128.29086.elendil@planet.nl>
In-Reply-To: <200910170128.29086.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910272200.07614.elendil@planet.nl>
X-OriginalArrivalTime: 27 Oct 2009 21:00:08.0140 (UTC) FILETIME=[772118C0:01CA5748]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 October 2009, Frans Pop wrote:
> On Saturday 17 October 2009, Mel Gorman wrote:
> > Frans, you reported that both patches in combination reduced the
> > number of failures. Was it in fact just the kswapd change that made
> > the difference?
>
> I will retest both patches (as I already mailed you privately
> yesterday), but not today. The improvement with the combination was
> real, but I'm not sure which patch is the reason. I think the second,
> but I need to verify.
>
> I've done another 30 boots or so today, mainly in the "akpm" merge, and
> I've found new patterns that will help me nail down the regression. But
> ATM I can't see straight anymore, so it will have to wait until
> tomorrow.

Again sorry for the delay, but I needed to retest these with various 
kernels as the results were inconclusive. AFAICT neither of the two 
patches makes a significant difference for my test case.

Not sure if my initial test was broken or that it was just a case where the 
timings worked out favorably.

Cheers,
FJP
