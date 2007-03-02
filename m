Return-Path: <linux-kernel-owner+w=401wt.eu-S2992732AbXCBXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992732AbXCBXVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992735AbXCBXVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:21:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992732AbXCBXVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:21:31 -0500
Message-ID: <45E8B147.4070104@redhat.com>
Date: Fri, 02 Mar 2007 18:20:39 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Bill Irwin <bill.irwin@oracle.com>,
       Christoph Lameter <clameter@engr.sgi.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie>	<20070301160915.6da876c5.akpm@linux-foundation.org>	<45E842F6.5010105@redhat.com>	<20070302085838.bcf9099e.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>	<20070302093501.34c6ef2a.akpm@linux-foundation.org>	<45E8624E.2080001@redhat.com>	<20070302100619.cec06d6a.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>	<45E86BA0.50508@redhat.com>	<20070302211207.GJ10643@holomorphy.com>	<45E894D7.2040309@redhat.com>	<20070302135243.ada51084.akpm@linux-foundation.org>	<45E89F1E.8020803@redhat.com>	<20070302142256.0127f5ac.akpm@linux-foundation.org>	<45E8A677.7000205@redhat.com> <20070302145906.653d3b82.akpm@linux-foundation.org>
In-Reply-To: <20070302145906.653d3b82.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Somehow I don't believe that a person or organisation which is incapable of
> preparing even a simple testcase will be capable of fixing problems such as
> this without breaking things.

I don't believe anybody who relies on one simple test case will
ever be capable of evaluating a patch without breaking things.

Test cases can show problems, but fixing a test case is no
guarantee at all that your VM will behave ok with real world
workloads.  Test cases for the VM can *never* be relied on
to show that a problem went away.

I'll do my best, but I can't promise a simple test case
for every single problem that's plaguing the VM.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
