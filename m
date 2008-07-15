Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYGOX3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYGOX3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYGOX3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:29:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbYGOX3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:29:31 -0400
Date: Tue, 15 Jul 2008 16:28:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487D3C17.31467.1C3C0441@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D3056.1183.1C0E1C47@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, pageexec@freemail.hu wrote:
>
> you should check out the last few -stable releases then and see how
> the announcement doesn't ever mention the word 'security' while fixing
> security bugs

Umm. What part of "they are just normal bugs" did you have issues with?

I expressly told you that security bugs should not be marked as such, 
because bugs are bugs. 

> in other words, it's all the more reason to have the commit say it's
> fixing a security issue.

No.

> > I'm just saying that why mark things, when the marking have no meaning? 
> > People who believe in them are just _wrong_.
> 
> what is wrong in particular?

You have two cases:

 - people think the marking is somehow trustworthy.

   People are WRONG, and are misled by the partial markings, thinking that 
   unmarked bugfixes are "less important". They aren't.

 - People don't think it matters

   People are right, and the marking is pointless.

In either case it's just stupid to mark them. I don't want to do it, 
because I don't want to perpetuate the myth of "security fixes" as a 
separate thing from "plain regular bug fixes".

They're all fixes. They're all important. As are new features, for that 
matter.

> when you know that you're about to commit a patch that fixes a security 
> bug, why is it wrong to say so in the commit?

It's pointless and wrong because it makes people think that other bugs 
aren't potential security fixes.

What was unclear about that?

		Linus
