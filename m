Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbZCTTqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbZCTTqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761043AbZCTTqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:46:34 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:52685 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761289AbZCTTqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:46:33 -0400
Date: Fri, 20 Mar 2009 15:43:23 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V5
In-Reply-To: <20090320162716.GP24586@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903201503040.11746@qirst.com>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201059240.3740@qirst.com> <20090320153723.GO24586@csn.ul.ie> <alpine.DEB.1.10.0903201205260.18010@qirst.com> <20090320162716.GP24586@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Mel Gorman wrote:

> > Is it possible to go to a simple
> > linked list (one cacheline to be touched)?
>
> I considered it but it breaks the hot/cold allocation/freeing logic and
> the search code became weird enough looking fast enough that I dropped
> it.

Maybe it would be workable if we drop the cold queue stuff (dubious
anyways)?

