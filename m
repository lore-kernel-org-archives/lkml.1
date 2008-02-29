Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYB2FCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYB2FCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYB2FBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:01:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38596 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750789AbYB2FBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:01:51 -0500
Date: Thu, 28 Feb 2008 23:01:40 -0600
From: Paul Jackson <pj@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
Subject: Re: [PATCH 5/6] Filter based on a nodemask as well as a gfp_mask
Message-Id: <20080228230140.321581a4.pj@sgi.com>
In-Reply-To: <20071109143406.23540.41284.sendpatchset@skynet.skynet.ie>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
	<20071109143406.23540.41284.sendpatchset@skynet.skynet.ie>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel wrote:
> A positive benefit of
> this is that allocations using MPOL_BIND now use the local-node-ordered
> zonelist instead of a custom node-id-ordered zonelist.

Could you update the now obsolete documentation (perhaps just delete
the no longer correct remark):

Documentation/vm/numa_memory_policy.txt:

        MPOL_BIND:  This mode specifies that memory must come from the
        set of nodes specified by the policy.

            The memory policy APIs do not specify an order in which the nodes
            will be searched.  However, unlike "local allocation", the Bind
            policy does not consider the distance between the nodes.  Rather,
            allocations will fallback to the nodes specified by the policy in
            order of numeric node id.  Like everything in Linux, this is subject
            to change.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
