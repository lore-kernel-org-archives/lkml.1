Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbXDFTDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbXDFTDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXDFTDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:03:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38622 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbXDFTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:03:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46169968.2050006@s5r6.in-berlin.de>
Date: Fri, 06 Apr 2007 21:03:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
References: <11757099691323-git-send-email-tony@atomide.com> <200704051119.11944.david-b@pacbell.net> <Pine.LNX.4.61.0704052232540.6042@yvahk01.tjqt.qr> <200704061029.55710.david-b@pacbell.net>
In-Reply-To: <200704061029.55710.david-b@pacbell.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
[...]
>>> 1	if (To control chain reactions, your odds
>>> 2			Improve if you've got cadmium rods) {
>>> 3		In your fission reactor
>>> 4		Their lack is a factor
>>> 5	}
>>> 6	In screams of "A meltdown! Ye gods!"
>>>
>>> Now, the former makes it hard to tell what's condition vs consequent.
>>> (Or whatever the correct technical term is in cases like these.)
>> My fu dictates that continuation lines (line 2 in this example)
>> should have more indent than line 1, 
> 
> Yes.  Where "indent" is measured -- always!! -- in tabs.
> Documentation/Coding style is quite explicit on that point:
> 
> 	Outside of comments, documentation and except in Kconfig,
> 	spaces are never used for indentation ...

I usually indent this way if expressions exceed the 80 columns limit:

	if (foo___________ &&
	    bar___________) {
		doit;
	}
and
	if ((one___________ ||
	     one_and_a_half) &&
	    two___________) {
		doit;
	}
and
	call(abc_______,
	     def___);
and

static int definition(abc_______,
		      def___)
{
...

and I know I'm not the only one.  Yes, this means I indent with tabs and
spaces --- if I wrap within expressions or within lists of function
arguments.  Of course there are always leading tabs before spaces, never
leading spaces.

PS:  Everyone please try to avoid blowing CodingStyle up to a 200 pages
document.  Thanks.
-- 
Stefan Richter
-=====-=-=== -=-- --==-
http://arcgraph.de/sr/
