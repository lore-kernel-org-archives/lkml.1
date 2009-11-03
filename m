Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZKCPb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZKCPb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZKCPb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:31:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbZKCPb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:31:58 -0500
Date: Tue, 3 Nov 2009 07:31:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Johannes Berg <johannes@sipsolutions.net>
cc: Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <1257234299.28469.25.camel@johannes.local>
Message-ID: <alpine.LFD.2.01.0911030726420.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain> <1257234299.28469.25.camel@johannes.local>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Johannes Berg wrote:
> 
> I'll rant a bit too -- I've been very annoyed by this many times. Note
> this isn't really against you (Dmitry) in particular, just another
> case ... but it does tick me off that many times when somebody manages
> to blame a failure on a specific commit the first thing they do is ask
> somebody way "above" (in terms of patch flow into mainline) the person
> writing the patch (like Linus here) to revert it.

Johannes, you're simply WRONG.

At this point (ie _way_ after -rc1), "just revert it" really is the right 
thing to do. The commit was shit. It caused more problems than it fixed. I 
should have reverted it immediately when that was clear. I didn't, and 
because I didn't, other people then had to waste time bisecting it.

So instead of complaining about other people, I would suggest you look 
yourself in the mirror. Stop thinking you "own" code. If you wrote a buggy 
commit, and somebody else went through the work to bisect it, you should 
 (a) expect it to be reverted
 (b) thank the person for finding the bug YOU introduced.
 (c) be ashamed of YOURSELF
instead of whining about it as if we should thank you!

		Linus
