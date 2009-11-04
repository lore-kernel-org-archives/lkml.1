Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZKDCI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZKDCI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZKDCI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:08:56 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:62117 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbZKDCI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:08:56 -0500
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
Date: Wed, 4 Nov 2009 03:08:56 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <20091104011811.GG22046@csn.ul.ie> <200911040305.59352.elendil@planet.nl>
In-Reply-To: <200911040305.59352.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911040308.59981.elendil@planet.nl>
X-OriginalArrivalTime: 04 Nov 2009 02:08:59.0888 (UTC) FILETIME=[C5CDAF00:01CA5CF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Frans Pop wrote:
> The congestion_wait() change, even if theoretically valid, introduced a
> very real regression IMO. Such long desktop freezes during swapping
> should be avoided; .30 and earlier simply behaved a whole lot better in
> the same situation.

I'll see if your new patch helps for this case.
