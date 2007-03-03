Return-Path: <linux-kernel-owner+w=401wt.eu-S2992964AbXCCDPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992964AbXCCDPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 22:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXCCDPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 22:15:44 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37508 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992961AbXCCDPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 22:15:43 -0500
Date: Fri, 2 Mar 2007 19:15:38 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Bill Irwin <bill.irwin@oracle.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070303003319.GB23573@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703021913030.31787@schroedinger.engr.sgi.com>
References: <20070302093501.34c6ef2a.akpm@linux-foundation.org>
 <45E8624E.2080001@redhat.com> <20070302100619.cec06d6a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>
 <45E86BA0.50508@redhat.com> <20070302211207.GJ10643@holomorphy.com>
 <45E894D7.2040309@redhat.com> <20070302135243.ada51084.akpm@linux-foundation.org>
 <45E89F1E.8020803@redhat.com> <20070302142256.0127f5ac.akpm@linux-foundation.org>
 <20070303003319.GB23573@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, William Lee Irwin III wrote:

> On Fri, Mar 02, 2007 at 02:22:56PM -0800, Andrew Morton wrote:
> > Opterons seem to be particularly prone to lock starvation where a cacheline
> > gets captured in a single package for ever.
> 
> AIUI that phenomenon is universal to NUMA. Maybe it's time we
> reexamined our locking algorithms in the light of fairness
> considerations.

This is a phenomenon that is usually addressed at the cache logic level. 
Its a hardware maturation issue. A certain package should not be allowed
to hold onto a cacheline forever and other packages must have a mininum 
time when they can operate on that cacheline.



