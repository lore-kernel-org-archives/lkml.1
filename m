Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZKMS0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZKMS0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbZKMS02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:26:28 -0500
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:59428 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786AbZKMS0Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:26:24 -0500
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] vmscan: Stop kswapd waiting on congestion when the min watermark is not being met
Date: Fri, 13 Nov 2009 19:26:21 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <20091113142608.33B9.A69D9226@jp.fujitsu.com> <20091114023138.3DA5.A69D9226@jp.fujitsu.com> <20091113181557.GM29804@csn.ul.ie>
In-Reply-To: <20091113181557.GM29804@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911131926.25291.elendil@planet.nl>
X-OriginalArrivalTime: 13 Nov 2009 18:26:25.0283 (UTC) FILETIME=[CEE68D30:01CA648E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009, Mel Gorman wrote:
> If reclaim fails to make sufficient progress, the priority is raised.
> Once the priority is higher, kswapd starts waiting on congestion.
>  However, if the zone is below the min watermark then kswapd needs to
> continue working without delay as there is a danger of an increased rate
> of GFP_ATOMIC allocation failure.
>
> This patch changes the conditions under which kswapd waits on
> congestion by only going to sleep if the min watermarks are being met.
>
> This patch replaces
> vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-troub
>le.patch .
>
> [mel@csn.ul.ie: Add stats to track how relevant the logic is]
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

For this to work with git-am, the From: line has to be _above_ the patch 
description (must be the first line of the mail even). AFAIK at least.

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Cheers,
FJP
