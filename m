Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZIQLik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZIQLik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZIQLik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:38:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:51715 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZIQLij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:38:39 -0400
Date: Thu, 17 Sep 2009 13:38:37 +0200
From: Nick Piggin <npiggin@suse.de>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917113837.GK18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <4AB21C3D.2080202@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB21C3D.2080202@in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 04:53:41PM +0530, Sachin Sant wrote:
> Mel Gorman wrote:
> >I have access to a ppc machine but not necessarily one with a memoryless 
> >nodes
> >that can reproduce this problem.
> >
> >Assuming Sachin is the reporter and we are in the same company, maybe I
> >have access to the machine. Sachin, can you mail me privately what this
> >machine is called and lets see can I get some time on that machine? By
> >any chance, was this bisected or did it just show up when SLQB became
> >the default?
> >  
> Mel,
> 
> Have sent you the access details for the machine. This bug showed
> up when SLQB was enabled as default in linux-next

Maybe it will be better to hold off merging until this is
debugged then? If it is merged as a non-default option, then
I can't see it being a huge issue to merge it a bit after the
window? It doesn't touch anything else...



