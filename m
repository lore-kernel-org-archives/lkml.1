Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbXILU2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbXILU2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbXILU23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:28:29 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:46522 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbXILU23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:28:29 -0400
Subject: Re: [PATCH 0/6] Use one zonelist per node instead of multiple
	zonelists v5 (resend)
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20070911213006.23507.19569.sendpatchset@skynet.skynet.ie>
References: <20070911213006.23507.19569.sendpatchset@skynet.skynet.ie>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 12 Sep 2007 16:27:33 -0400
Message-Id: <1189628853.5004.66.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 22:30 +0100, Mel Gorman wrote:
> (Sorry for the resend, I mucked up the TO: line in the earlier sending)
> 
> This is the latest version of one-zonelist and it should be solid enough
> for wider testing. To briefly summarise, the patchset replaces multiple
> zonelists-per-node with one zonelist that is filtered based on nodemask and
> GFP flags. I've dropped the patch that replaces inline functions with macros
> from the end as it obscures the code for something that may or may not be a
> performance benefit on older compilers. If we see performance regressions that
> might have something to do with it, the patch is trivially to bring forward.
> 
> Andrew, please merge to -mm for wider testing and consideration for merging
> to mainline. Minimally, it gets rid of the hack in relation to ZONE_MOVABLE
> and MPOL_BIND.


Mel:

I'm just getting to this after sorting out an issue with the memory
controller stuff in 23-rc4-mm1.  I'm building all my kernels with the
memory controller enabled now, as it hits areas that I'm playing in.  I
wanted to give you a heads up that vmscan.c doesn't build with
CONTAINER_MEM_CONT configured with your patches.  I won't get to this
until tomorrow.  Since you're a few hours ahead of me, you might want to
take a look.  No worries, if you don't get a chance...

Later,
Lee

