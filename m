Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYH0M0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYH0M0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYH0M0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:26:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:23993 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYH0M0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qBp/yDiaRBRvwDfAgt+qmIu/l/otNUUGeZBtENrGCwJPBOxrIA7lLjxuogNPbxnV9h
         qT1tfNneg9pj7zb4zsUs3QwDpeaKV0hJ4lZnwu2ohKEddB27mCuReIvLEA0hb7fX5yFa
         2KzxU/u58ghiGFWaTYGWld6i3rPok9bKc46/I=
Message-ID: <1ba2fa240808270526g163f8c0an3c5d220cce69466c@mail.gmail.com>
Date: Wed, 27 Aug 2008 15:26:17 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: johannes@sipsolutions.net, holtmann@linux.intel.com,
       linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080827.044551.102233262.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba2fa240808270305m7f505efak9fd0d36d5db09a1e@mail.gmail.com>
	 <1219831828.3891.3.camel@johannes.berg>
	 <1ba2fa240808270434y1589761xd2ff0a48c2e99033@mail.gmail.com>
	 <20080827.044551.102233262.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 2:45 PM, David Miller <davem@davemloft.net> wrote:
> From: "Tomas Winkler" <tomasw@gmail.com>
> Date: Wed, 27 Aug 2008 14:34:28 +0300
>
>> Unfortunately fixing bugs on stable branch take precedence  of
>> adjusting to new API on development branch that someone decided to do.
>>  I wanted to work directly on wireless testing but it was broken over
>> an over and I have only limited resources more in testing then in
>> development I just had to branch out to be ready with the driver when
>> HW is out. People just check the immediate impact of they fix the
>> don't test for collateral damage and this is understandable an
>> individual developer doesn't have lab with IBSS, BSS, AP, etc setups.
>
> But think about this from the other perspective.
>
> When you queue up tons of things, especially in infrastructure level
> code such as mac80211, and on top of it you do your work on the stable
> branch and do not do you work against the development tree, guess what
> happens?

> You show up with accumulated piles of non-trivial patches for people
> to review.  And then you'll get upset when they suggest that things be
> implemented differently.

I never worked that way I've published immediately what I had. I don't
know where  did you get this impression
 If I didn't publish something it's just too reasons.
The code was made dirty and I didn't like design myself (for example
our 11h implementation), even though it's publicly available.
or just simply didn't have time because I have to satisfy first thous
who pays my check ( everybody to feed their children after all:) )
(e.g. rfkill fixes)
Almost every driver has it's own development branch, we didn't do
something different here, this is just classical divide and conquer
strategy.

> It's all because of the gap in time.
>
> And during this time, if you had submitted earlier, you would end up
> doing smaller and mode gradual modifications to your design.  And
> you'd take care of them before they effect subsequent pieces of work
> you want to do which depend upon the earlier bits.
>
> The longer you queue stuff up, the more painful having to change stuff
> at the beginning of that queue becomes.  It can invalidate everything
> else you worked on.
>
> The only sane way to operate is to post your work early and often, or
> else you'll live in a world of hurt, and it will be nobody's fault but
> your own.

This is all understood and this would be indeed the ideal case.
Tomas
