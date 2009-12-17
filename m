Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbZLQV6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbZLQV6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763094AbZLQV6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:58:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762686AbZLQV6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:58:50 -0500
Date: Thu, 17 Dec 2009 13:58:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] vfs pile 2
In-Reply-To: <20091217214320.GG18217@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0912171350540.15740@localhost.localdomain>
References: <20091217162454.GA18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain> <20091217180319.GB18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912171008220.15740@localhost.localdomain> <20091217183952.GC18217@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.0912171316220.15740@localhost.localdomain> <20091217214320.GG18217@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Dec 2009, Al Viro wrote:
> 
> Yeah, but why aren't they put into local pack?  They _are_ new and they
> definitely are referenced.  The newest in the repository, as the matter
> of fact.
> 
> Odd...

Hmm. It seems to be the same objects that are unpacked in my repo. What 
happens is probably that git doesn't want to pack them, because they are 
available in the alternates, but then also doesn't want to prune them, 
because they aren't available in a _pack_ in the alternate.

That does look like something we migth decide to want to change in git. 
Maybe. 

But I repacked my repo, just so that you can get your "no loose objects" 
situation you want ;)

		Linus
