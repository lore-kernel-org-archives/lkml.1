Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZBWRcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZBWRcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZBWRbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:31:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33779 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZBWRbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:31:50 -0500
Date: Mon, 23 Feb 2009 18:49:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
Message-ID: <20090223174947.GT26292@one.firstfloor.org>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <87ljryuij0.fsf@basil.nowhere.org> <20090223143232.GJ6740@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223143232.GJ6740@csn.ul.ie>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hmm, it would be ideal but I haven't looked too closely at how it could
> be implemented. I thought first you could just associate a zonelist with

Yes like that. This was actually discussed during the initial cpuset
implementation. I thought back then it would be better to do it
elsewhere, but changed my mind later when I saw the impact on the
fast path.

> the cpuset but you'd need one for each node allowed by the cpuset so it
> could get quite large. Then again, it might be worthwhile if cpusets

Yes you would need one per node, but that's not a big problem because
systems with lots of nodes are also expected to have lots of memory.
Most systems have a very small number of nodes.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
