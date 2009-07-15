Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZGON5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZGON5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZGON5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:57:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50412 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbZGON5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:57:33 -0400
Date: Wed, 15 Jul 2009 10:56:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/3] net-dccp: Suppress warning about large allocations
	from DCCP
Message-ID: <20090715135630.GC19645@ghostprotocols.net>
References: <1247656992-19846-1-git-send-email-mel@csn.ul.ie> <1247656992-19846-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247656992-19846-4-git-send-email-mel@csn.ul.ie>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 15, 2009 at 12:23:12PM +0100, Mel Gorman escreveu:
> The DCCP protocol tries to allocate some large hash tables during
> initialisation using the largest size possible.  This can be larger than
> what the page allocator can provide so it prints a warning. However, the
> caller is able to handle the situation so this patch suppresses the warning.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Thanks again,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
