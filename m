Return-Path: <linux-kernel-owner+w=401wt.eu-S965641AbXEAIUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbXEAIUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXEAIUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:20:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965641AbXEAIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:20:24 -0400
Date: Tue, 1 May 2007 01:19:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.22 -mm merge plans -- pfn_valid_within
Message-Id: <20070501011935.a2b90633.akpm@linux-foundation.org>
In-Reply-To: <4636F626.7030609@shadowen.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<4636F626.7030609@shadowen.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 09:11:18 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> Andrew Morton wrote:
> 
> >  add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
> >  anti-fragmentation-switch-over-to-pfn_valid_within.patch
> >  lumpy-move-to-using-pfn_valid_within.patch
> > 
> > More Mel things, and linkage between Mel-things and lumpy reclaim.  It's here
> > where the patch ordering gets into a mess and things won't improve if
> > moveable-zones and lumpy-reclaim get deferred.  Such a deferral would limit my
> > ability to queue more MM changes for 2.6.23.
> 
> The first of these is really a cleanup and should slide into the stack
> before Mobility and Lumpy.  The other two should then join their
> respective stacks anti-fragmentation-... to Mobility and lumpy-... to
> Lumpy.  I would not expect them to increase linkage that way.
> 

yup, that improved things a bit, thanks.

