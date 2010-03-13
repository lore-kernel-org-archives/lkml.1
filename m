Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024Ab0CMLMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:12:24 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:17750 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab0CMLMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:12:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=c7MVhOA90UYzlWvuer7QNUbOx8rLLj9GGcMMeFytZcutsk9LAm1/BW67HC/AeBt/gz
         cYtmNGtFZR1WT3U+wYnaK3y0EdOI/StT3OrOzIE5zsS2CiLAbnWhOvTZYKE38agTJtbp
         RM13I7ks2R6QLvtqUO9CtoLYmiRxUMe9Tw0+g=
Message-ID: <4B9B7312.80301@gmail.com>
Date: Sat, 13 Mar 2010 06:12:18 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dan Carpenter <error27@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Michael Chan <mchan@broadcom.com>,
       Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v4 2/7] net: remove old tcp_optlen function
References: <4B98D592.6040301@gmail.com> <4B98D9A2.8060603@gmail.com>	 <4B9A40BC.4030301@gmail.com> <20100312174656.GA12175@bicker>	 <4B9AC8C5.2010300@gmail.com> <1268471488.2947.26.camel@edumazet-laptop>
In-Reply-To: <1268471488.2947.26.camel@edumazet-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/10 4:11 AM, Eric Dumazet wrote:
> David already pointed out fact that this code path is not used in
> forwardind / routing path. Your assumptions are clearly wrong.
>
> Can you sit down and understand this difference ?
>
> Only *locally* generated trafic by linux kernel can enter this path.
>
Since you agree with David, perhaps you could kindly point out exactly
how your statement is true?  Proof by assertion is generally not good
argumentation.  I'll start a new thread for you to discuss.

More importantly, how is this relevant to this patch?

This patch removes a seldom used function that generates bad code, and
MUST NOT be used elsewhere in the code base -- an attractive nuisance,
speaking in legal terms.

This patch is also more elegant, and generates faster code.

Are you saying this patch is incorrect in any way?

Please point to the bad line of code (not David's comments or diatribe).
Certainly, I'll be happy to correct it!


> And if a bug in linux core network stack can feed any driver a buggy
> skb, bad things can happen, even if a driver is perfect.
>
Certainly.  But a driver cannot depend on the entirety of a large
project being perfect.  It *should* be perfect in and of itself!


> Please point out _this_ bug _if_ it really exists, so that we can
> correct this bug instead of hiding it in one thousand of drivers.
>
Again, I'll start a new thread for your edification.


> Your attacks make no sense, you know nothing about linux kernel
> internals and assume it was written like other projects you were
> involved to.
>
I've made no "attacks".  The above is a personal /ad hominem/ attack,
evidently the raison d'etre for Linux email lists.  :-(

Yes, I've been involved in many other projects, and am arguably the
most widely experienced TCP/IP implementer in the world.  I've been
programming in C since 1977, and my first TCP/IP implementation was
started in 1979 (in assembly).  Probably before you were born.

Why are you so threatened by that?

Why are you insulting and trying to drive me away?

Why, oh why, is there such a lack of community spirit here?!?!
