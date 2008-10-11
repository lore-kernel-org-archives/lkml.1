Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYJKHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYJKHMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYJKHMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:12:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43564 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbYJKHMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:12:06 -0400
Date: Sat, 11 Oct 2008 09:11:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bug] latest -git boot hang
Message-ID: <20081011071128.GO19428@kernel.dk>
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EFF84B.5060108@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11 2008, Tejun Heo wrote:
> Hello,
> 
> Linus Torvalds wrote:
> > On Fri, 10 Oct 2008, Ingo Molnar wrote:
> >> | 870d6656126add8e383645732b03df2b7ccd4f94 is first bad commit
> >> | commit 870d6656126add8e383645732b03df2b7ccd4f94
> >> | Author: Tejun Heo <tj@kernel.org>
> >> | Date:   Mon Aug 25 19:47:25 2008 +0900
> >> |
> >> |     block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT
> >>
> >> and meanwhile 2 other test-systems failed to boot as well - both have 
> >> CONFIG_DEBUG_BLOCK_EXT_DEVT=y.
> >>
> >> So i guess this debug feature is working as expected.
> > 
> > Ahh, yeah, sounds that way.
> > 
> >> I guess we should mark CONFIG_DEBUG_BLOCK_EXT_DEVT=y as really dangerous 
> >> to enable because contemporary distributions (i tried Fedora 9) fail 
> >> with it too?
> > 
> > Tejun - do you know whether _any_ distro will boot with 
> > CONFIG_DEBUG_BLOCK_EXT_DEVT=y?
> 
> Hmmm... openSUSE 11.0 didn't have any problem with it, which I was a bit
> pleasantly surprised about.  I haven't tested management tools but the
> base system worked just fine.

10.3 worked here too, and iirc the ubuntu on my laptop did too. It's
been a month or so since I tested though, so...

> > It does sound like perhaps the option should be hidden more, if it's 
> > really only reasonably enabled for some very specialized distro debuggers, 
> > not normal kernel people.
> 
> Yeap, if fedora didn't work, I think it should be hidden.  Do we already
> have place to hide things like this?

Agree, lets make it more of an effort to enable, it should not be
something that the casual user comes across and thinks it would
interesting to try. Or at least make it clear from the help text that
this may result in a non-booting system on some distros.

-- 
Jens Axboe

