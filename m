Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbYDUI6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbYDUI6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYDUI6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:58:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41180
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbYDUI6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:58:36 -0400
Date: Mon, 21 Apr 2008 01:58:37 -0700 (PDT)
Message-Id: <20080421.015837.35795810.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
 latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080421082254.GA2522@elte.hu>
References: <20080419103942.GA13599@elte.hu>
	<20080419.040945.13369499.davem@davemloft.net>
	<20080421082254.GA2522@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 Apr 2008 10:22:54 +0200

> * David Miller <davem@davemloft.net> wrote:
> 
> > You haven't cared about how I push my trees to Linus for years, why is 
> > it a problem all of a sudden?
> 
> the answer is simple, and it has nothing to do with you or with 
> networking at all: i'm maintaining about 10 times more code (and more 
> commits) than before.

Then, I can only conclude what several others have also concluded, that
you've taken on x86 maintainence purely so that you can berate other
subsystem maintainers who don't do things up to your specifications
and standards.

And frankly Ingo, that sucks.

Instead of discussing things with people, you get up every morning and
shoot off your randconfig nuclear bombs at your targets.  It's what
you've done all weekend long and it's very much NOT appreciated.

The build failure knowledge is appreciated, however the reason you are
reporting them is not.  Why do we need to know that your automated
tools have found 5 networking build failures "so far" over the
weekend?  That number is relative to what, exactly?  It has no purpose
other as a tool that lets you say "networking broke the build,
substantially, see?"  And for the record most of what you've
discovered are extreme edge cases that our Kbuild language machinery
doesn't handle very well.

Now, as a result of doing x86 maintainence, you can say "see how well
I maintain a subsystem" and the implication is that the way other
people do their work results in a vastly inferier result.

And frankly Ingo, that also sucks.

All the while you have your randconfig machinery to "prove" things,
which allows you to bypass any suspicion of targetting anyone on
ideological grounds.

If you really cared, you would run your randconfig system on, for
example, the linux-next and -mm trees, which I've specifically
suggested and you've specifically ignored.  And there is no
coincidence to that.

You'd rather not do it, and the reason is that doing so would actually
help Linux kernel development as a whole rather than serve your
specific political and ideological goals.

And that, Ingo, really sucks.
