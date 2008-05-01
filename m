Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYEAESM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYEAESM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYEAER5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:17:57 -0400
Received: from [207.36.208.214] ([207.36.208.214]:37186 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYEAER4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:17:56 -0400
Message-ID: <48194464.2000406@garzik.org>
Date: Thu, 01 May 2008 00:17:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Mackerras <paulus@samba.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <18457.219.995207.136771@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0804302034180.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804302034180.5994@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> But there could be some kind of carrot here - maybe I could maintain a 
> "next" branch myself, not for core infrastructure, but for stuff where the 
> maintainer says "hey, I'm ready early, you can pull me into 'next' 
> already".
> 
> In other words, it wouldn't be "core infrastructure", it would simply be 
> stuff that you already know you'd send to me on the first day of the merge 
> window. And if by maintaining a "next" branch I could encourage people to 
> go early, _and_ let others perhaps build on it and sort out merge 
> conflicts (which you can't do well on linux-next, exactly because it's a 
> bit of a quick-sand and you cannot depend on merging the same order or 
> even the same base in the end), maybe me having a 'next' branch would be 
> worth it.

linux-next is _supposed_ to be solely the stuff that is ready to be sent 
to you upon window-open.

The only thing that isn't reliable are the commit ids -- and that's at 
the request of a large majority of maintainers, who noted to Stephen R 
that the branch he was pulling from them might get rebased -- thus 
necessitating the daily tree regeneration.

So, I think a 'next' branch from you would open cans o worms:

- one more tree to test, and judging from linux-next and -mm it's tough 
to get developers to test more than just upstream

- is the value of holy penguin pee great enough to overcome this 
another-tree-to-test obstacle?

- opens all the debates about running parallel branches, such as, would 
it be better to /branch/ for 2.6.X-rc, and then keep going full steam on 
the trunk?  After all, the primary logic behind 2.6.X-rc is to only take 
bug fixes, theoretically focusing developers more on that task.  But now 
we are slowly undoing that logic, or at least openly admitting that has 
been the reality all along.

	Jeff



