Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXCVAA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXCVAA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965483AbXCVAA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:00:27 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965485AbXCVAAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:00:24 -0400
Date: Wed, 21 Mar 2007 16:56:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-Id: <20070321165650.8e765756.akpm@linux-foundation.org>
In-Reply-To: <20070321234236.GD9092@redhat.com>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
	<p73y7lu5yt6.fsf@bingen.suse.de>
	<20070320165736.GA19781@redhat.com>
	<20070320181442.1ae73295@lxorguk.ukuu.org.uk>
	<20070321151952.02b5612d.akpm@linux-foundation.org>
	<20070321231935.GC9092@redhat.com>
	<20070321162717.34edb348.akpm@linux-foundation.org>
	<20070321234236.GD9092@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 19:42:36 -0400
Dave Jones <davej@redhat.com> wrote:

> On Wed, Mar 21, 2007 at 04:27:17PM -0700, Andrew Morton wrote:
>  > > [1] Though admittedly the one in RHEL deviates from upstream
>  > > as it contains performance enhancements that were vetoed from
>  > > upstream acceptance due to it being "deprecated".
>  > 
>  > What enhancements are they?
> 
> Hmm, actually it seems I was mistaken, we didn't merge those after all,
> we seem to be shipping what was upstream in 2.6.9/2.6.18.
> 
> The patches I was thinking of were a bunch of optimisations for higher
> throughput from someone at Intel iirc. Ken Chen maybe?

Ah, OK.

Ken had an initial set of patches which weren't very popular.  Months
later, he had a second set which did get merged into mainline, but they
broke, so that code is presently mucking up fs/block_dev.c, inside #if 0,
awaiting possible repair.


