Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYDUIOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYDUIOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYDUIOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:14:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56119 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbYDUIOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:14:36 -0400
Message-ID: <480C4CE8.6020202@garzik.org>
Date: Mon, 21 Apr 2008 04:14:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kaber@trash.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, NetDev <netdev@vger.kernel.org>
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on	latest
 -git
References: <20080419100034.GA9475@elte.hu> <20080419.030337.244502148.davem@davemloft.net> <20080419103942.GA13599@elte.hu>
In-Reply-To: <20080419103942.GA13599@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Sat, 19 Apr 2008 12:00:35 +0200
>>
>>> btw., i found no thread to reply to on lkml or elsewhere - arent all 
>>> git pull requests supposed to be Cc:-ed to lkml, with shortlog 
>>> included?
>> I have never once done this even going all the way back to the BK 
>> days.
> 
> do you find this practice of private pull requests important? If not, 
> would it be difficult to Cc: lkml to routine pull requests?
> 
>> I always send my pull requests directly to Linus, CC:'ing Andrew.
> 
> that makes bugs harder to report and makes the flow of patches harder to 
> follow as well. Often (like in this case) i see it when a bug comes in 
> via a specific group of commits but i have no time to do a bisection. In 
> that case i'd like to report it to that pull request so i'd like to 
> reply to that pull on lkml.
> 
> But in this case i first did an unsuccessful full-text search on lkml, 
> then i also opened up netdev and did a full text search there too to 
> find the originator pull request or the patches but the search turned up 
> nothing. As the number of subsystems increases, i suspect you agree with 
> me that this does not scale very well for bug reporters, correct?

Well, 'git log [$file]' is even more scalable and precise, if committer 
(as well as author) info and patch flow info is what a tester or bug 
reporter seeks.

But it sounds like you are making an assumption about development 
/style/, then complaining when reality doesn't match that assumption.


> i'm convinced that testers and bug reporters are the scarce resource 
> these days, not patch integrators and not maintainers which was the 
> scarce resource 3-4 years ago, before Git and before BK. It is testing 
> (and review) capacity that limits the growth of Linux today, not patch 
> writing and patch integration capacity.

We're all for more bug reports and testing, but the link you are trying 
to draw is more than a little overblown.  I'm not convinced LKML's lack 
of davem pull request visibility is a problem source limiting the growth 
of Linux today...  That's a bit much.  :)

AFAICT you and davem have different development styles, he doesn't work 
the way you work, but the tone of your emails recently has been "if you 
do not fit my preferred development worldview, you are creating problems 
for Linux."  Witness not just this thread, but the LKML-vs-netdev 
discussions.

	Jeff


