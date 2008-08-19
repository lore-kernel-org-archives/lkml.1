Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYHSW1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYHSW1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYHSW06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:26:58 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:48414 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbYHSW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:26:56 -0400
Date: Wed, 20 Aug 2008 02:26:12 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20080819222612.GA16766@2ka.mipt.ru>
References: <alpine.LFD.1.10.0808191411390.3324@nehalem.linux-foundation.org> <20080819.142735.179034162.davem@davemloft.net> <alpine.LFD.1.10.0808191432040.3324@nehalem.linux-foundation.org> <20080819.144015.40311904.davem@davemloft.net> <alpine.LFD.1.10.0808191446560.3324@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808191446560.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 02:50:36PM -0700, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> And the thing is, you cannot. Some of the ones I pointed you to were 
> actually regressions due to _other_ patches you had much too happily sent 
> me after the merge window had already closed).

... phisiological thoughts skipped ...

> Please. You're still making excuses for this, even after I pointed out 
> that ALL of the problems with the whole loopback driver thing happened 
> after the merge window. 

I belive it was you who told that there is no black and white (another
guy told that there is no spoon, I frequntly confuse).

Any changes made no matter when can not be 100% tested in laboratory
environment, even fixes, which look obviously. Even changes which do fix
some problems can introduce another. And some fixes can introduce
problems, which are not immediately shown in majority of the tests, so
changes on top of them can look like introducing new bugs. If you have
multiple changes and result which produce an error, it does not mean
that the last one was wrong. Of course it can, but 'there is no black
and white', and in really complex system only trivial changes can be
thought of not touching others. The same applies to loopback. So this
particular note is just about the fact, that fixing regression means
either reverting a change or introducing a new change. The latter is
preferred (or at least should be), since it is a move forward.

According to other changes, which you believe are not suitable for the
post merge window releases... People do know that major changes are not
allowed to be made, but there are always last strikes in the head which
are supposed to fix problems, not to introduce new ones. Where did you
see experimental code in -rc cycle? Where did you see patches which
break things without bringing improvement at that time? Yes, there
changes which are not supposed to be in the tree at that time, but
that's just a development process, which even in a short run makes good
result. Regressions and bugs are fixed, and things are not getting worse
with time.

-- 
	Evgeniy Polyakov
