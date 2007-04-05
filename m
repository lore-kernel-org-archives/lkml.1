Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXDES3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXDES3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXDES3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:29:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63768 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbXDES3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:29:37 -0400
Message-ID: <46154006.4090103@oracle.com>
Date: Thu, 05 Apr 2007 11:29:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
References: <11757099691323-git-send-email-tony@atomide.com> <Pine.LNX.4.61.0704050359320.22282@yvahk01.tjqt.qr> <46147888.2080507@oracle.com> <200704051119.11944.david-b@pacbell.net>
In-Reply-To: <200704051119.11944.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Wednesday 04 April 2007 9:18 pm, Randy Dunlap wrote:
> 
>> I don't think it's a MUA thing.  I think David is talking about the
>> spaces after the ^\t that are used for indenting immediately under
>> the "if".
> 
> Exactly.
> 
> 	if (There was a young lady named Bright
> 		Whose speed was far faster than light) {
> 		She set out one day
> 		in a relative way
> 	}
> 	And returned on the previous night
> 
> obeys the only-ident-by-tabs rule, as does
> 
> 	if (To control chain reactions, your odds
> 			Improve if you've got cadmium rods) {
> 		In your fission reactor
> 		Their lack is a factor
> 	}
> 	In screams of "A meltdown! Ye gods!"
> 
> Now, the former makes it hard to tell what's condition vs consequent.
> (Or whatever the correct technical term is in cases like these.)

Yes.  And the second one is just ugly IMHO.
That's why 3 of us (IIRC) have suggested using a few spaces on
multi-line "if" statements rather than many-tabs.  Like so:

> 	if (There was a young lady named Bright
> 	    Whose speed was far faster than light) {
> 		She set out one day
> 		in a relative way
> 	}
> 	And returned on the previous night

but I'm ready to drop it and hope that I never have to look at
that code.  :)

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
