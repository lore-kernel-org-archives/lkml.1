Return-Path: <linux-kernel-owner+w=401wt.eu-S1763960AbZD3OKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763960AbZD3OKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763487AbZD3OKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:10:02 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34845 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762587AbZD3OKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:10:00 -0400
Date: Thu, 30 Apr 2009 15:09:57 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Eric Lacombe <goretux@gmail.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [unused symbol] need to use init_mm
Message-ID: <20090430140957.GD21997@csn.ul.ie>
References: <200904301232.05302.goretux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200904301232.05302.goretux@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 12:32:04PM +0200, Eric Lacombe wrote:
> Hi,
> 
> Within a module I work on, I need to access to init_mm, but as it is marked 
> UNUSED, I wonder if there is another way (an API) to access to it.
> Otherwise, what can I do to have this mark removed from init_mm in the 
> mainline? as my module is really not yet ready for inclusion.
> 
> Thanks in advance for your response,
> 

It looks to be that it was removed already, somewhat behind schedule, in
commit 9470565579f29486f4ed0ffa50774268b64994b0 after an initial attempt
was made in commit 3abf024d2abb79614d8c4cb25a70d5596f77d0ad.  I don't know
if there is a procedure for bringing it back but I would guess it's a call
for the x86 maintainers. I imagine they will want to at least know;

1. Why do you need init_mm exported?
2. Is there an alternative approach to using init_mm?
3. Assuming yes, what are the downsides?
4. When do you think the module will be ready for posting?  i.e. is this
   really something destined for mainline or some perma-out-of-tree?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
