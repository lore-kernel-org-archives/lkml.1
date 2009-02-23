Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZBWIey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZBWIey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZBWIeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:34:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:27330 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZBWIep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:34:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,253,1233561600"; 
   d="scan'208";a="388965082"
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <84144f020902222329u5754f8b1k790809191ac48f4a@mail.gmail.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <84144f020902222329u5754f8b1k790809191ac48f4a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 16:34:25 +0800
Message-Id: <1235378065.2604.434.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 09:29 +0200, Pekka Enberg wrote:
> On Mon, Feb 23, 2009 at 1:17 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > The complexity of the page allocator has been increasing for some time
> > and it has now reached the point where the SLUB allocator is doing strange
> > tricks to avoid the page allocator. This is obviously bad as it may encourage
> > other subsystems to try avoiding the page allocator as well.
> 
> I'm not an expert on the page allocator but the series looks sane to me.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Yanmin, it would be interesting to know if we still need 8K kmalloc
> caches with these patches applied. :-)
We are running testing against the series of patches on top of 2.6.29-rc5, and
will keep you posted on the results.


