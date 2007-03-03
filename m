Return-Path: <linux-kernel-owner+w=401wt.eu-S1030700AbXCCRvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700AbXCCRvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030701AbXCCRvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:51:05 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37463 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030700AbXCCRvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:51:04 -0500
Date: Sat, 3 Mar 2007 09:50:58 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: "Martin J. Bligh" <mbligh@mbligh.org>
cc: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Bill Irwin <bill.irwin@oracle.com>,
       Mel Gorman <mel@skynet.ie>, npiggin@suse.de, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <45E9AD74.4060704@mbligh.org>
Message-ID: <Pine.LNX.4.64.0703030942490.921@schroedinger.engr.sgi.com>
References: <20070302093501.34c6ef2a.akpm@linux-foundation.org>
 <45E8624E.2080001@redhat.com> <20070302100619.cec06d6a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>
 <45E86BA0.50508@redhat.com> <20070302211207.GJ10643@holomorphy.com>
 <45E894D7.2040309@redhat.com> <20070302135243.ada51084.akpm@linux-foundation.org>
 <45E89F1E.8020803@redhat.com> <20070302142256.0127f5ac.akpm@linux-foundation.org>
 <20070303003319.GB23573@holomorphy.com> <Pine.LNX.4.64.0703021913030.31787@schroedinger.engr.sgi.com>
 <45E9AD74.4060704@mbligh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007, Martin J. Bligh wrote:

> That'd be nice. Unfortunately we're stuck in the real world with
> real hardware, and the situation is likely to remain thus for
> quite some time ...

Our real hardware does behave as described and therefore does not suffer 
from the problem.

If you want a software solution then you may want to look at Zoran 
Radovic's work on Hierachical Backoff locks. I had a draft of a patch a 
couple of years back that showed some promise to reduce lock contention. 
HBO locks can solve starvation issues by stopping local lock takers.

See Zoran Radovic "Software Techniques for Distributed Shared Memory", 
Uppsala Universitet, 2005 ISBN 91-554-6385-1.

http://www.gelato.org/pdf/may2005/gelato_may2005_numa_lameter_sgi.pdf

http://www.gelato.unsw.edu.au/archives/linux-ia64/0506/14368.html
