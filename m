Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYCARWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYCARWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 12:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYCARWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 12:22:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbYCARWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 12:22:30 -0500
Date: Sat, 1 Mar 2008 12:21:56 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-mm@kback.org
Subject: Re: [rfc 10/10] Pageflags land grab
Message-ID: <20080301122156.5994b949@bree.surriel.com>
In-Reply-To: <20080301040622.220638278@sgi.com>
References: <20080301040534.797979115@sgi.com>
	<20080301040622.220638278@sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 20:05:44 -0800
Christoph Lameter <clameter@sgi.com> wrote:

> We have enough page flags after vmemmap no longer uses section ids.
> 
> Reserve 5 of the 6 saved flags for functionality that is currently
> under development in the VM.
> 
> The new flags are only available if either of these conditions are met:
> 
> 1. 64 Bit system. (then we have 8 more free of the 32)
> 
> 2. !NUMA. In that case 2 bits are needed for the zone
>    id which leaves 30 page flag bits. Of those we use 24. 6 left.
> 
> 3. !SPARSEMEM. In that case we use 5 bits of the 30 available
>    for the node. 1 leftover.
> 
> 4. SPARSEMEM_VMEMMAP. Case 3 applies.

Nice!  I like your patch series.

-- 
All rights reversed.
