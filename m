Return-Path: <linux-kernel-owner+w=401wt.eu-S1765613AbXIMS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765613AbXIMS3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbXIMS3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:29:01 -0400
Received: from smtpoutm.mac.com ([17.148.16.75]:52039 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432AbXIMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:29:00 -0400
In-Reply-To: <Pine.LNX.4.64.0709131706100.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709120242040.1817@scrub.home> <20070913075258.GA9173@elte.hu> <Pine.LNX.4.64.0709131419170.1817@scrub.home> <20070913142842.GA26016@elte.hu> <Pine.LNX.4.64.0709131706100.1817@scrub.home>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D1C6ACC2-FD90-4813-84C9-A23531684B86@mac.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [announce] CFS-devel, performance improvements
Date: Thu, 13 Sep 2007 14:28:13 -0400
To: Roman Zippel <zippel@linux-m68k.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 13, 2007, at 12:50:12, Roman Zippel wrote:
> On Thu, 13 Sep 2007, Ingo Molnar wrote:
>> And you are duly credited in 3 patches:
>
> This needs a little perspective, as I couldn't clone the repository  
> (and you know that), all I had was this announcement, so using the  
> patch descriptions now as defense is unfair by you.

How the hell is that unfair?  The fact that nobody could clone the  
repo for about 24 hours is *totally* *irrelevant* to the whole  
discussion as it's simply a matter of a technical glitch.  His point  
in referencing patch descriptions is to clear up matters of credit.   
Ingo has never in this discussion been "out to get you".  From the  
point of view of a sideline observer it's been *you* that has been  
demanding answers and refusing to answer questions directed at you.

The most brilliant mathematician in the world would have nothing to  
contribute to the Linux scheduler if he couldn't describe, code, and  
comment his algorithm in detail so that others (even code-monkeys  
like myself) could grok at least the basic outline and be able to  
give useful commentary and suggestions.


> In this announcement you make relatively few references how this  
> relates to my work.  Maybe someone else can show me how to read  
> that announcement differently, but IMO the casual reader is likely  
> to get the impression, that you only picked some minor cleanups  
> from my patch, but it's rather unclear that you already  
> reimplemented key aspects of my patch.

As a casual reader and reviewer I have yet to actually see you post  
readable/reviewable patches in this thread.  I was basically  
completely unable to follow the detailed math you go into (even with  
a math minor) due to your *complete* lack of comments.  The fact that  
you renamed files and didn't split up your patch made it useless for  
actual practical kernel development, its only value was as a  
comparison point.  I did however get the impression that Ingo got  
something significantly useful out of your code despite the problems,  
but I still haven't had time to read through his and Peter's patches  
in detail to understand exactly what it was.  From personal  
inspection of a fair percentage of the changes that Ingo and Peter  
committed, they certainly appear to be deleting a lot more code than  
they add.  More specifically they appear to describe in detail what  
they are deleting and why, with the exception of one patch that's  
missing a changelog entry.

So yeah, I get the impression that Ingo re-implemented some ideas  
that you had because you refused to do so in a way that was  
acceptable for the upstream kernel.  How exactly is this a bad  
thing?  You came up with a great idea that worked and somebody else  
did the ugly grunt work to get it ready to go upstream!  On the other  
hand, given the "pleasant" attitude that you've showed Ingo during  
this whole thing I doubt he'd be likely to do it again.


>> You never directly replied to these pretty explicit requests, all  
>> you did was this side remark 5 days later in one of your patch  
>> announcements:
>
> This is ridiculous, I asked you multiple times to explain to me  
> some of the differences relative to CFS as response to the splitup  
> requests. Not once did you react, you didn't even ask what I'd like  
> to know specifically.

How exactly is Ingo supposed to explain to YOU the differences  
between his scheduler and your modified one?  Completely ignoring the  
fact that you merged all your changes into a single patch and didn't  
add a single comment, it's not *his* algorithm that I have trouble  
understanding.  From a relatively basic scan of the source-code and  
comments I was able to figure out how the algorithm works in general,  
enough to ask much more specific questions than yours.  If anything,  
Ingo should have been asking *you* how your scheduler differed from  
the one it was based on.


> I never claimed to understand every detail of CFS, I can _guess_  
> what _might_ have been intended, but from that it's impossible to  
> know for certain how important they are. Let's take this patch  
> fragment:

Oh come on, you appear to be quite knowledgeable about CPU scheduling  
and the algorithms involved, surely as such you should have a much  
easier time with reading the comments and asking specific questions.   
For example, your below question specifically about the sleep  
averaging could have been answered in fifteen minutes had you  
actually *ASKED* that.  You'll notice that in fact Peter Zijlstra's  
email response did come almost exactly 15 minutes after you sent this  
email, and for a casual reader like me it seems perfectly  
sufficient;  it does depend on you asking specific questions instead  
of "how does it differ from my hundred-kbyte patch".

As for that specific patch, it's very clear that the affected logic  
is controlled by one of the sched-feature tweaking tools, so you  
could very easily experiment with it yourself to see what the  
differences are when the feature is on or off and whether or not it's  
useful or harmful for your workloads.  Such evidence would help  
indicate which way the scheduler feature should be hard-coded when  
the tunable is finally removed.

Cheers,
Kyle Moffett

