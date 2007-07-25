Return-Path: <linux-kernel-owner+w=401wt.eu-S1764821AbXGYHZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764821AbXGYHZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764421AbXGYHZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:25:22 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:43019 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764169AbXGYHZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:25:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=T4pR0h6GoQjFA23YCb/R1Gbk+rxY5eo7p3okMMCrZvsm4f/VMRAT3NKRK2lH+2iQna3knxot3+KCr2isV9KSQwtnzdwdVtvvfAd0hwb65l2SGeLENslW1o9Z7LnN7634AlANowcTccmrJQlSjhYLBHqNqryDLM39mnL2aNbAIJY=  ;
X-YMail-OSG: _6g8GFoVM1nlSUbIc73Tg7prma0nUD.AxwcoQb7x98m5izQ7hT0J2_HCq2n63jqKRiv.czojgg--
Message-ID: <46A6FAD8.6050107@yahoo.com.au>
Date: Wed, 25 Jul 2007 17:25:12 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: david@lang.hm
CC: Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>  <200707102015.44004.kernel@kolivas.org>  <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>  <46A57068.3070701@yahoo.com.au>  <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>  <46A58B49.3050508@yahoo.com.au>  <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>  <46A6CC56.6040307@yahoo.com.au>  <46A6D7D2.4050708@gmail.com> <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au> <Pine.LNX.4.64.0707242252250.2229@asgard.lang.hm> <46A6E80B.6030704@yahoo.com.au> <Pine.LNX.4.64.0707242316410.2229@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707242316410.2229@asgard.lang.hm>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Wed, 25 Jul 2007, Nick Piggin wrote:

>> And constructed test cases of course are useful as well, I didn't say
>> they weren't. I don't know what you mean by "acceptable", but you should
>> read my last paragraph again.
> 
> 
> this problem has been around for many years, with many different people 
> working on solutions. it's hardly a case of getting a proposal and 
> trying to get it in without anyone looking at other options.

What is "this problem"? People have an updatedb problem that is solved
by swap prefetching which I want to fix in a different way.

There would be a different problem of "run something that uses heaps of
memory and swap everything else out, then quit it, wait for a while, and
swap prefetching helps". OK, definitely swap prefetching would help there.
How much? I don't know. I'd be slightly surprised if it was like an order
of magnitude, because not only swap but everything else has been thrown
out too.


> it seems that there are some people (not nessasarily including you) who 
> will oppose this feature until a test is created that shows that it's 
> better. the question is what sort of test will be accepted as valid? I'm 
> not useing this patch, but it sounds as if the people who are useing it 
> are interested in doing whatever testing is required, but so far the 
> situation seems to be a series of "here's a test", "that test isn't 
> valid, try again" loops. which don't seem to be doing anyone any good 

And yet despite my repeated pleas, none of those people has yet spent a
bit of time with me to help analyse what is happening.


> and are frustrating lots of people, so like several people over the last 
> few days O'm asking the question, "what sort of test would be acceptable 
> as proof that this patch does some good?"

I don't think any further proof is needed that the patch does "some"
good. Rig up a test case and you could see some seconds shaved off it.
Maybe you want to know "how to get this patch merged"? And I don't know
that one. I do know that it is fuzzy, and probably doesn't include
demanding things of Andrew or Linus.

BTW. If you find out the answer to that one, let me know because I have
this lockless pagecache patch that has also been around for years, is
also just a few hundred lines in the VM, and does do some good too. I'm
sure the buffered AIO people and many others would also like to know.

-- 
SUSE Labs, Novell Inc.
