Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbXEAILR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbXEAILR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXEAILQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:11:16 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2065 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbXEAILO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:11:14 -0400
Message-ID: <4636F626.7030609@shadowen.org>
Date: Tue, 01 May 2007 09:11:18 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.22 -mm merge plans -- pfn_valid_within
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>  add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
>  anti-fragmentation-switch-over-to-pfn_valid_within.patch
>  lumpy-move-to-using-pfn_valid_within.patch
> 
> More Mel things, and linkage between Mel-things and lumpy reclaim.  It's here
> where the patch ordering gets into a mess and things won't improve if
> moveable-zones and lumpy-reclaim get deferred.  Such a deferral would limit my
> ability to queue more MM changes for 2.6.23.

The first of these is really a cleanup and should slide into the stack
before Mobility and Lumpy.  The other two should then join their
respective stacks anti-fragmentation-... to Mobility and lumpy-... to
Lumpy.  I would not expect them to increase linkage that way.

-apw
