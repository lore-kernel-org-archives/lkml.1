Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXDFVkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXDFVkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXDFVkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:40:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40601 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089AbXDFVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:40:08 -0400
Message-ID: <4616BE59.20300@oracle.com>
Date: Fri, 06 Apr 2007 14:40:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
References: <11757099691323-git-send-email-tony@atomide.com> <200704061029.55710.david-b@pacbell.net> <46169968.2050006@s5r6.in-berlin.de> <200704061405.50169.david-b@pacbell.net>
In-Reply-To: <200704061405.50169.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 06 April 2007 12:03 pm, Stefan Richter wrote:
> 
>> I usually indent this way if expressions exceed the 80 columns limit:
>>
>> 	if (foo___________ &&
>> 	    bar___________) {
>> 		doit;
>> 	}
>> and
>> 	if ((one___________ ||
>> 	     one_and_a_half) &&
>> 	    two___________) {
>> 		doit;
>> 	}
>> and
>> 	call(abc_______,
>> 	     def___);
>> and
>>
>> static int definition(abc_______,
>> 		      def___)
>> {
>> ...
> 
> Please change your coding style to conform to Documentation/CodingStyle.
> 
> 	***	Only indent with tabs!!		***
> 
> Every one of those examples violates that simple rule.
> 
> Why does *anyone* have even the slightest difficulty understanding such a
> simple rule?  I realize that two of those words have more than a single
> syllable, but that should not be a problem.  Even EMACS is trainable.
> 
> 
>> PS:  Everyone please try to avoid blowing CodingStyle up to a 200 pages
>> document.  Thanks.
> 
> Better yet, try to stick to its guidelines rather than growing lots of
> exceptions saying when your personal style says you ought to use spaces
> instead of tabs for indents, etc
> 
> 
> Randy, next time you criticise coding style, please make sure that the
> code in question actually violates the existing rules first ... this
> thread has been way too much noise, given that the usage you criticized
> was in full conformance with that document, and the proposed fixes were
> in blatant violation ...

Yeah, well, I've already given up.  But please try to understand,
David, that CodingStyle can have mistakes in it, just like some of
the kernel code does.  And like I said earlier, it's just a set of
guidelines.

And I haven't seen any flamage here (referring to another posting).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
