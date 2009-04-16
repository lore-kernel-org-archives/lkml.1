Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZDPU4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZDPU4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZDPU4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:56:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbZDPU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:56:05 -0400
Date: Thu, 16 Apr 2009 13:53:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add "how to write a good patch summary"
 to SubmittingPatches
In-Reply-To: <20090416204650.GN7138@mit.edu>
Message-ID: <alpine.LFD.2.00.0904161350310.4042@localhost.localdomain>
References: <1239882285-4994-1-git-send-email-tytso@mit.edu> <20090416201255.GA21608@elte.hu> <20090416204650.GN7138@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Theodore Tso wrote:

> On Thu, Apr 16, 2009 at 10:12:55PM +0200, Ingo Molnar wrote:
> > as a bug triager i can, within 1 minute, sort all the commits by 
> > risk:
> > 
> > Low risk cleanups:
> >     ...
> > Runtime crash fixes:
> >     ...
> > Robustness enhancements:
> >     ...
> > Low-risk features:
> >     ...
> > High-risk features:
> >     ...
> 
> Sure, but if that's the goal, maybe instead we should have some
> keywords that we tag onto one-line summary, i.e.
> 
> ext4 <LR,cleanup>: 

Hell no.

The fact is, those "low risk cleanups" break things.

People who think that you can assess the risk of a commit before-hand and 
then rely on it are clueless morons.

Stop doing this. If we're just talking about some machine-readable pattern 
matching, JUST DON'T DO IT. It's going to be wrong. It's going to be wrong 
because people don't do it right, but it's going to be wrong because even 
when people _do_ mark everything right, they'll still be wrong.

Write English. Don't maek some idiotic commit markers that will make 
things harder to read AND WILL BE WRONG.

			Linus
