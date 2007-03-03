Return-Path: <linux-kernel-owner+w=401wt.eu-S2992787AbXCCAeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992787AbXCCAeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992805AbXCCAeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:34:13 -0500
Received: from holomorphy.com ([66.93.40.71]:43136 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992787AbXCCAeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:34:13 -0500
Date: Fri, 2 Mar 2007 16:33:19 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Bill Irwin <bill.irwin@oracle.com>,
       Christoph Lameter <clameter@engr.sgi.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070303003319.GB23573@holomorphy.com>
References: <20070302093501.34c6ef2a.akpm@linux-foundation.org> <45E8624E.2080001@redhat.com> <20070302100619.cec06d6a.akpm@linux-foundation.org> <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com> <45E86BA0.50508@redhat.com> <20070302211207.GJ10643@holomorphy.com> <45E894D7.2040309@redhat.com> <20070302135243.ada51084.akpm@linux-foundation.org> <45E89F1E.8020803@redhat.com> <20070302142256.0127f5ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302142256.0127f5ac.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 02:22:56PM -0800, Andrew Morton wrote:
> Opterons seem to be particularly prone to lock starvation where a cacheline
> gets captured in a single package for ever.

AIUI that phenomenon is universal to NUMA. Maybe it's time we
reexamined our locking algorithms in the light of fairness
considerations.


-- wli
