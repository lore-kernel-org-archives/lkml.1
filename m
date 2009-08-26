Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZHZVTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZHZVTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZHZVTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:19:10 -0400
Received: from lucidpixels.com ([75.144.35.66]:57365 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZHZVTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:19:10 -0400
Date: Wed, 26 Aug 2009 17:19:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <20090826180234.GC14019@infradead.org>
Message-ID: <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
References: <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan> <20090822142550.GA10003@infradead.org> <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
 <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan> <20090823224504.GA19942@infradead.org> <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan> <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
 <20090826180234.GC14019@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Aug 2009, Christoph Hellwig wrote:

> On Wed, Aug 26, 2009 at 09:50:27AM -0400, Justin Piszcz wrote:
>> So far the uptime is 2 days, if it does not recur in the next 24-48
>> hours, do you recommend I follow up with the linux-crypto folks about
>> this?  It appears this could be the cause (no issues, as of yet).
>
> At this point it doesn't look crypto related anymore, but like some
> bad interaction between layers once we add those fsync in the loop code.
>
> What filesystem does you loop image reside on?   Anything else special?
For the root filesystem, on / type xfs (rw,noatime)
For larger partitions (per the cryptoloop doc) the partition itself is 
setup via cryptoloop and then XFS ontop of that.  Nothing special.


> Any way to trgiger it with just loop but not crypto, etc.
Unfortunately not that I am aware of..  Would trying the kernel with the 
patch removed and mounted with -o nobarrier help to show us anything, or?

>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
