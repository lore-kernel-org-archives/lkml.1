Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXDFXwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXDFXwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933458AbXDFXwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:52:36 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:48586 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455AbXDFXwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:52:35 -0400
Date: Sat, 7 Apr 2007 01:50:42 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Brownell <david-b@pacbell.net>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
In-Reply-To: <200704061540.34500.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.61.0704070141000.22181@yvahk01.tjqt.qr>
References: <11757099691323-git-send-email-tony@atomide.com>
 <200704061357.03700.david-b@pacbell.net> <Pine.LNX.4.61.0704062354530.6042@yvahk01.tjqt.qr>
 <200704061540.34500.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 15:40, David Brownell wrote:
>> >	if (...) {
>> >		THAT WAS ONE MORE TAB
>> >	}
>> >
>> >Come on, stop wasting everyone's time with utter nonsense.
>> I was never debating these two things. 
>Actually, you did.

If it was perceived I did, then I owe you an apology.

>Go back and see the point I was specifically
>disagreeing with.  It related to the body of the "if" block,
>which you had said would **NOT** indent by a single tab.

Ok somewhere is a bug. What is the body an if block, for you? To avoid
that confusion, I termed these "condition" and "code":

	if(condition1 ||	/* if() line */
	    condition2) {	/* continuation line */
		code;		/* body */
		code;		/* body */
	}

And I think I made that pretty clear in <http://lkml.org/lkml/2007/4/5/293>,
which part is what, and how I like things.
In <http://lkml.org/lkml/2007/4/6/133>, the loop begins then.
Yes, it does not match "(a) only use tabs", but it matches the
rest of kernel code.


Jan
-- 
