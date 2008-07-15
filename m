Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbYGOUn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbYGOUn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761842AbYGOUnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:43:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756192AbYGOUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:43:42 -0400
Date: Tue, 15 Jul 2008 13:42:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487D2371.10258.1BDBBC00@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.10.0807151331110.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D20EC.26203.1BD1E5C5@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151317270.2867@woody.linux-foundation.org> <487D2371.10258.1BDBBC00@pageexec.freemail.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
> 
> i understand and i think noone expects that. in fact, i know how much
> expertise and time it takes to determine that. but what happens when
> you do figure out the security relevance of a bug during bug submission

The issue is that I think it's then _misleading_ to mark that kind of 
commit specially, when I actually believe that it's in the minority.

If people think that they are safer for only applying (or upgrading to) 
certain patches that are marked as being security-specific, they are 
missing all the ones that weren't marked as such. Making them even 
_believe_ that the magic security marking is meaningful is simply a lie. 
It's not going to be.

So why would I add some marking that I most emphatically do not believe in 
myself, and think is just mostly security theater?

I generally do not remove peoples changelog entries, although I _will_ 
do even that if I think it's just too much of an actual exploit 
description (of course - the patch itself can make the exploit fairly 
clear). So you'll find CVE entries etc in the logs if you look.

But I do hope that anybody who looks for them is _aware_ that it's just a 
small minority of possible problems.

Don't get me wrong - I'm not saying that security bugs are _common_, but 
especially some local DoS thing for a specific driver or filesystem or 
whatever can be a big security problem for _somebody_.

			Linus


