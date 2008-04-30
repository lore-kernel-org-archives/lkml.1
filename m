Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbYD3Os6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbYD3Os6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbYD3Osu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:48:50 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:15731 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbYD3Ost (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UmUx1LTVeTGGmlV9NE7RyOI6UTb+i80fx79GVw/MC8TjQk4QCQ4ESZDxQQ3WmMy8zvQfBfhM35P+sREIlirPvxxD9aBhW4Nq168xEU9J1crPGKKzNzQyPI6yl2bIDDptgBUd8kG37Q5/pn0uQQJWK9FnXPBAimZckYPdJ3TZqjw=
Message-ID: <804dabb00804300748x3f363710k5bc8f5728a1587e6@mail.gmail.com>
Date: Wed, 30 Apr 2008 22:48:47 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Slow DOWN, please!!!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080429.190352.137408408.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429.190352.137408408.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:03 AM, David Miller <davem@davemloft.net> wrote:
>
>  This is starting to get beyond frustrating for me.
>
>  Yesterday, I spent the whole day bisecting boot failures
>  on my system due to the totally untested linux/bitops.h
>  optimization, which I fully analyzed and debugged.
>
>  Today, I had hoped that I could get some work done of my
>  own, but that's not the case.
>
>  Yet another bootup regression got added within the last 24
>  hours.
>
>  I don't mind fixing the regression or two during the merge
>  window but THIS IS ABSOLUTELY, FUCKING, REDICULIOUS!
>
>  The tree breaks every day, and it's becomming an extremely
>  non-fun environment to work in.
>
>  We need to slow down the merging, we need to review things
>  more, we need people to test their fucking changes!
>  --

Just some comments:

Analogous to that of the football team, everyone has an impt role to
play.   And u better let go of the ball as fast as u can, otherwise u
are going to tire yourself out easily.

So, in a development team, if u think there is some unequal
distribution of workload, make noise.   Or think of some means to do
automatic loading of workload - specifically in the area of change
review.   (At other times, it is not easily to pass the load
around.....eg, if the bug happened only on your machines and not on
others?)

1.   Generally, the more people reviewed the work, the higher chances
the piece of work is ok.

2.   If more variation of real-testing is done, the better.
"variation" here means testing by users of different background
skills, different applications running, and most impt - is the base
kernel version where the patch is applied and tested. etc.

3.   Based on the two numbers above alone, we can immediately have
some measure of confidence of the patch - correct?

4.   So if we can put all these in a web page - the patches itself,
the reviewers/testers that have worked on it.

When someone comes in and review, review counter increase by one.   Or
tester counter increased by one after testing.

And I supposed everyone will attempt to cover those that are lesser
covered by others - automatic loading of workload done in a
distributed manner.

Avoid having to fill in too much information though...u will
discourage taking up the work, and let the participant spent more
precious time on reviewing instead.

So prior to consolidation of sources, just by looking at the numbers,
u can see how successful the consolidation will be.   If it is lesser
tested, then avoid including it for consoldating......

Please comments......
-- 
Regards,
Peter Teoh
