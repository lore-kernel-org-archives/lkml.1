Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXAXDQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXAXDQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 22:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030243AbXAXDQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 22:16:04 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:55957 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030190AbXAXDQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 22:16:02 -0500
Date: Tue, 23 Jan 2007 19:14:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Aubrey Li <aubreylee@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, dgc@sgi.com
Subject: Re: [RFC] Limit the size of the pagecache
In-Reply-To: <45B6CBD9.80600@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701231908420.6123@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
 <45B6CBD9.80600@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, Nick Piggin wrote:

> > 1. Insure that anonymous pages that may contain performance
> >    critical data is never subject to swap.
> > 
> > 2. Insure rapid turnaround of pages in the cache.
> 
> So if these two aren't working properly at 100%, then I want to know the
> reason why. Or at least see what the workload and the numbers look like.

The reason for the anonymous page may be because data is rarely touched 
but for some reason the pages must stay in memory. Rapid turnaround is 
just one of the reason that I vaguely recall but I never really 
understood what the purpose was.

> > 3. Reserve memory for other uses? (Aubrey?)
> 
> Maybe. This is still a bad hack, and I don't like to legitimise such use
> though. I hope Aubrey isn't relying on this alone for his device to work
> because his customers might end up hitting fragmentation problems sooner
> or later.

I surely wish that Aubrey would give us some more clarity on 
how this should work. Maybe the others who want this feature could also 
speak up? I am not that clear on its purpose.
