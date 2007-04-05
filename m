Return-Path: <linux-kernel-owner+w=401wt.eu-S1767242AbXDEUik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767242AbXDEUik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767222AbXDEUij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:38:39 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:48344 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767242AbXDEUig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:38:36 -0400
Date: Thu, 5 Apr 2007 22:35:39 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Brownell <david-b@pacbell.net>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
In-Reply-To: <200704051119.11944.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.61.0704052232540.6042@yvahk01.tjqt.qr>
References: <11757099691323-git-send-email-tony@atomide.com>
 <Pine.LNX.4.61.0704050359320.22282@yvahk01.tjqt.qr> <46147888.2080507@oracle.com>
 <200704051119.11944.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 5 2007 11:19, David Brownell wrote:
>On Wednesday 04 April 2007 9:18 pm, Randy Dunlap wrote:
>
>> I don't think it's a MUA thing.  I think David is talking about the
>> spaces after the ^\t that are used for indenting immediately under
>> the "if".
>
>Exactly.
>
>1	if (There was a young lady named Bright
>2		Whose speed was far faster than light) {
>3		She set out one day
>4		in a relative way
>5	}
>6	And returned on the previous night
>
>obeys the only-ident-by-tabs rule, as does
>
>1	if (To control chain reactions, your odds
>2			Improve if you've got cadmium rods) {
>3		In your fission reactor
>4		Their lack is a factor
>5	}
>6	In screams of "A meltdown! Ye gods!"
>
>Now, the former makes it hard to tell what's condition vs consequent.
>(Or whatever the correct technical term is in cases like these.)

My fu dictates that continuation lines (line 2 in this example)
should have more indent than line 1, and that the inner block code
(lines 3 and 4) should have more indent than line 2. Using
/^\t+\x20{2,8}/ on continuation line(s) is perfect because it does
not cause either the continuation line(s) or the inner block code to
move too much to the right.


Jan
-- 
