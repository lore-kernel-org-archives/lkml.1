Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXCBVNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXCBVNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965640AbXCBVNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:13:39 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:27013 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965645AbXCBVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:13:38 -0500
Date: Fri, 2 Mar 2007 13:12:07 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302211207.GJ10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Rik van Riel <riel@redhat.com>,
	Christoph Lameter <clameter@engr.sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@skynet.ie>, npiggin@suse.de, mingo@elte.hu,
	jschopp@austin.ibm.com, arjan@infradead.org,
	torvalds@linux-foundation.org, mbligh@mbligh.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <45E842F6.5010105@redhat.com> <20070302085838.bcf9099e.akpm@linux-foundation.org> <Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com> <20070302093501.34c6ef2a.akpm@linux-foundation.org> <45E8624E.2080001@redhat.com> <20070302100619.cec06d6a.akpm@linux-foundation.org> <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com> <45E86BA0.50508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E86BA0.50508@redhat.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 01:23:28PM -0500, Rik van Riel wrote:
> With 32 CPUs diving into the page reclaim simultaneously,
> each trying to scan a fraction of memory, this is disastrous
> for performance.  A 256GB system should be even worse.

Thundering herds of a sort pounding the LRU locks from direct reclaim
have set off the NMI oopser for users here.


-- wli
