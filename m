Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbZABR7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbZABR7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbZABR7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:59:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757678AbZABR7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:59:35 -0500
Date: Fri, 2 Jan 2009 09:58:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
In-Reply-To: <20090102174641.GA27287@elte.hu>
Message-ID: <alpine.LFD.2.00.0901020953280.5086@localhost.localdomain>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu>
 <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102174641.GA27287@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Jan 2009, Ingo Molnar wrote:
> 
> The gcc3 check for gcc 3.0 and 3.1 can be pushed into gcc3 as well - not 
> sure whether you fixed that. (i fixed it in the patch i just sent - but i 
> didnt notice the gcc5 mess in gcc4.h that you fixed)

I just dropped it. Gcc 3.0 and 3.1 are so old that we simply don't care. 

Nobody who has compiled a kernel in the last two years can possibly have 
those versions: we've failed the build on them since December 2006. And 
there obviously won't be any new users either. So consider it a 
generational garbage collection event.

Of course, if we really want to check for old compiler versions, we can 
add the check back (to the gcc3 header file where it belongs), but it does 
seem to be entirely historical.

			Linus
