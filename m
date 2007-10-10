Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXJJCWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXJJCWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 22:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXJJCWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 22:22:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbXJJCWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 22:22:45 -0400
Date: Tue, 9 Oct 2007 19:22:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: remove zero_page (was Re: -mm merge plans for 2.6.24)
In-Reply-To: <200710091931.51564.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0710091917410.3838@woody.linux-foundation.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
 <200710090117.47610.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0710090750020.5039@woody.linux-foundation.org>
 <200710091931.51564.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Oct 2007, Nick Piggin wrote:
> 
> Where do you suggest I go from here? Is there any way I can
> convince you to try it? Make it a config option? (just kidding)

No, I'll take the damn patch, but quite frankly, I think your arguments 
suck.

I've told you so before, and asked for numbers, and all you do is 
handwave. And this is like the *third*time*, and you don't even seem to 
admit that you're handwaving.

So let's do it, but dammit:
 - make sure there aren't any invalid statements like this in the final 
   commit message.
 - if somebody shows that you were wrong, and points to a real load, 
   please never *ever* make excuses for this again, ok? 

Is that a deal? I hope we'll never need to hear about this again, but I 
really object to the way you've tried to "sell" this thing, by basically 
starting out dishonest about what the problem was, and even now I've yet 
to see a *single* performance number even though I've asked for them 
(except for the problem case, which was introduced by *you*)

		Linus
