Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXDFVrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXDFVrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXDFVrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:47:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49772 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbXDFVrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:47:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4616BFC5.2040307@s5r6.in-berlin.de>
Date: Fri, 06 Apr 2007 23:46:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
References: <11757099691323-git-send-email-tony@atomide.com> <200704061029.55710.david-b@pacbell.net> <46169968.2050006@s5r6.in-berlin.de> <200704061405.50169.david-b@pacbell.net>
In-Reply-To: <200704061405.50169.david-b@pacbell.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 06 April 2007 12:03 pm, Stefan Richter wrote:
> 
>> I usually indent this way if expressions exceed the 80 columns limit:

Or in other words:
  - When a new scope is opened, increase indentations by 8 characters.
    Use a tab for that.
  - When wrapping within an expression, start the new line at the same
    column at which the (sub-)expression started.
  - Deviations from the latter rule allowed if it increases readability.

> Please change your coding style to conform to Documentation/CodingStyle.

I won't change this anymore in any legacy code I write patches for.  But
I also won't stand in the way of anybody who happens to submit patches
which strictly only...

> 	***	Only indent with tabs!!		***

...indent with tabs and change legacy code whose maintainer I am.

> Every one of those examples violates that simple rule.
> 
> Why does *anyone* have even the slightest difficulty understanding such a
> simple rule?

/Does/ anybody have difficulties?

...
>> PS:  Everyone please try to avoid blowing CodingStyle up to a 200 pages
>> document.  Thanks.
> 
> Better yet, try to stick to its guidelines rather than growing lots of
> exceptions saying when your personal style says you ought to use spaces
> instead of tabs for indents, etc

What I said at the top of this posting has not been newly grown recently
but has been common practice for many years.  It's not my personal style.

(Note, I'm not saying one style is better than the other, nor am I
saying that only one style can be allowed, nor am I saying that it's
fine to have several different styles.)
-- 
Stefan Richter
-=====-=-=== -=-- --==-
http://arcgraph.de/sr/
