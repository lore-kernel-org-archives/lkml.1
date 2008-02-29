Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbYB2OtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbYB2OtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759163AbYB2OtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:49:16 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12332 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbYB2OtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:49:15 -0500
Subject: Re: [PATCH 5/6] Filter based on a nodemask as well as a gfp_mask
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
In-Reply-To: <20080228230140.321581a4.pj@sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
	 <20071109143406.23540.41284.sendpatchset@skynet.skynet.ie>
	 <20080228230140.321581a4.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 29 Feb 2008 09:49:24 -0500
Message-Id: <1204296564.5311.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-28 at 23:01 -0600, Paul Jackson wrote:
> Mel wrote:
> > A positive benefit of
> > this is that allocations using MPOL_BIND now use the local-node-ordered
> > zonelist instead of a custom node-id-ordered zonelist.
> 
> Could you update the now obsolete documentation (perhaps just delete
> the no longer correct remark):
> 
> Documentation/vm/numa_memory_policy.txt:
> 
>         MPOL_BIND:  This mode specifies that memory must come from the
>         set of nodes specified by the policy.
> 
>             The memory policy APIs do not specify an order in which the nodes
>             will be searched.  However, unlike "local allocation", the Bind
>             policy does not consider the distance between the nodes.  Rather,
>             allocations will fallback to the nodes specified by the policy in
>             order of numeric node id.  Like everything in Linux, this is subject
>             to change.
> 

Yes, will do.  

Thanks, Lee

