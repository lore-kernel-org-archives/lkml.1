Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbZDCRNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbZDCRNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbZDCRNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:13:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760559AbZDCRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:13:43 -0400
Date: Fri, 3 Apr 2009 10:02:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Felix Blyakher <felixb@sgi.com>,
       Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [GIT PULL] XFS update for 2.6.30
In-Reply-To: <alpine.LFD.2.00.0904030952220.4130@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904030954030.4130@localhost.localdomain>
References: <20090331053013.7642414167108@attica.americas.sgi.com> <BD6F95C9-2F2D-49A3-979C-25018E62E416@sgi.com> <alpine.LFD.2.00.0904030952220.4130@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Linus Torvalds wrote:

> 
> 
> On Thu, 2 Apr 2009, Felix Blyakher wrote:
> > 
> > Were there any problems pulling from the xfs repository?
> 
> Sorry, no - just too much email, too many trees to look at, too many 
> people to argue with.
> 
> Pulled.

Side note - I almost unpulled afterwards. 

You've done several apparently totally useless pulls from my tree at 
random points. 

Daily "keep up-to-date with Linus' tree" pulls are _strongly_ discouraged 
(read: if this continues, I'll just stop pulling from you), because it 
makes the history totally unreadable after-the-fact. It has some direct 
technical downsides (it makes it much harder to run "git bisect" and see 
what is going on), but apart from those direct downsides it just makes it 
much harder for me - or anybody else who wants to get an overview of what 
happened - to visualize things when history is messy.

Instead of having a clear nice line of development that says "this is what 
happened to XFS", those merges have basically mixed up all your changes 
with all the random _other_ changes in the tree. 

In other words, having those extra merges makes the graphical tools almost 
useless for getting some kind of "what happened" overview. 

I realize that an occasional back-merge may be required to resolve big 
conflicts early, but they really have to be pretty big and immediate for 
it to be a win. 

			Linus
