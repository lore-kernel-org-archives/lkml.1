Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZEQQ2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZEQQ2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 12:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZEQQ1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 12:27:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45909 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZEQQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 12:27:52 -0400
Date: Sun, 17 May 2009 17:27:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hartleys@visionengravers.com,
       mcrapet@gmail.com, fred99@carolina.rr.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] Double check memmap is actually valid with a memmap
	has unexpected holes V2
Message-ID: <20090517162701.GB2664@n2100.arm.linux.org.uk>
References: <20090505082944.GA25904@csn.ul.ie> <20090505083614.GA28688@n2100.arm.linux.org.uk> <20090505084928.GC25904@csn.ul.ie> <20090513163448.GA18006@csn.ul.ie> <20090513124805.9c70c43c.akpm@linux-foundation.org> <20090514083947.GB16639@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514083947.GB16639@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 09:39:47AM +0100, Mel Gorman wrote:
> It affected at least 2.6.28.4 so minimally, I'd like to see it in for 2.6.30.
> I think it's a -stable candidate but I'd like to hear from the ARM maintainer
> on whether he wants to push it or not to that tree.

I'm inclined to agree.

> > It applies OK to 2.6.28, 2.6.29, current mainline and mmotm, so I'll
> > just sit tight until I'm told what to do.
> > 
> 
> Please merge for 2.6.30 at least. Russell, are you ok with that? Are you ok
> with this being pushed to -stable?

I'll merge it into my master branch, which'll be going to Linus in the next
few days.
