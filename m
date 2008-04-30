Return-Path: <linux-kernel-owner+w=401wt.eu-S1765770AbYD3Xay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765770AbYD3Xay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbYD3Xaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:30:46 -0400
Received: from ozlabs.org ([203.10.76.45]:43515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYD3Xap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:30:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18457.219.995207.136771@cargo.ozlabs.ibm.com>
Date: Thu, 1 May 2008 09:29:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> So one of the major things about the short merge window is that it's 
> hopefully encouraging people to have things ready by the time the merge 
> window opens, because it's too late to do anything later.

Having things ready by the time the merge window opens is difficult
when you don't know when the merge window is going to open.  OK, after
you release a -rc6 or -rc7, we know it's close, but it could still be
three weeks off at that point.  Or it could be tomorrow.

That's mitigated at the moment by having the merge window be two weeks
long.  So if you open the merge window at a point where I, or someone
downstream of me, thought we still had two weeks to go, we can hurry
up and try to get stuff finished within the first week and still get
it merged.

But if you made a really hard and fast rule that only stuff that is in
linux-next at the point where the merge window opens can be merged,
AND the point at which the merge window opens is unknown and
unpredictable within a period of about 4 weeks, then that makes it
really tough for those of us downstream of you to plan our work.

By the way, if you do want to make that rule, then there's a really
easy way to do it - just pull linux-next, and make that one pull be
the entire merge window. :)  But please give us at least a week's
notice that you're going to do that.

Paul.
