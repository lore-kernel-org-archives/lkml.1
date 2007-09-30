Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbXI3SAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbXI3SAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 14:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbXI3SAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 14:00:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42161 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbXI3R77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:59:59 -0400
Date: Sun, 30 Sep 2007 10:59:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
Message-Id: <20070930105930.1b330c84.randy.dunlap@oracle.com>
In-Reply-To: <46FFDF7D.7080605@rtr.ca>
References: <200709300401.l8U41AhY024890@agora.fsl.cs.sunysb.edu>
	<46FFDF7D.7080605@rtr.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 13:40:13 -0400 Mark Lord wrote:

> Erez Zadok wrote:
> > In message <alpine.LFD.0.999.0709291748160.3579@woody.linux-foundation.org>, Linus Torvalds writes:
> >>
> >> On Sat, 29 Sep 2007, Erez Zadok wrote:
> >>> Would you prefer if CodingStyle was reorganized or even split into (1)
> >>> general principles and (2) details?  Perhaps we need a CodingStylePrinciples
> >>> and a CodingStyleDetails?
> >> I'm certainly ok with the split into two files.
> >>
> >> What I'm not ok with is really important stuff (indentation), and then 
> >> mixing in silly rules ("parenthesis are bad in printk's"?)
> >>
> >> 		Linus
> > 
> > OK, looking at CodingStyle, I see two kinds of chapters.  The first is stuff
> > that's more generic to C, and the other is more specific to Linux and how
> > one codes in the linux kernel.  So I propose the following:
> > 
> > 1. we create a new file called CodingSuggestions
> > 
> > 2. we keep in CodingStyle the following chapters
> > 
> >    Chapter 1: Indentation
> >    Chapter 2: Breaking long lines and strings
> >    Chapter 3: Placing Braces and Spaces
> >    Chapter 4: Naming
> >    Chapter 5: Typedefs
> >    Chapter 6: Functions
> >    Chapter 7: Centralized exiting of functions
> >    Chapter 8: Commenting
> >    Chapter 9: You've made a mess of it
> > 
> >    Note: I'd suggest we rename the title of ch9 to "Custom Editor
> >    Programming/Indentation Modes" or something more descriptive.
> > 
> >    Chapter 10: Kconfig configuration files
> >    Chapter 11: Data structures
> >    Chapter 12: Macros, Enums and RTL
> >    Chapter 15: The inline disease
> >    Chapter 16: Function return values and names
> >    Chapter 18: Editor modelines and other cruft
> > 
> > 3. move the following chapters to CodingSuggestions:
> > 
> >    Chapter 13: Printing kernel messages
> >    Note: ch13 is the one which mentions the don't put parentheses around %d.
> > 
> >    Chapter 14: Allocating memory
> >    Chapter 17: Don't re-invent the kernel macros
> >    Chapter 19: branch prediction optimizations (the un/likely debacle)
> 
> Super.  And then, in the spirit of Linus's request,
> we can submit another patch that simply removes that second file
> completely from the kernel source tree!

or just revert CodingStyle to its contents of say 4 years ago.

> Yay!  The suits actually lose for once!
> (okay, so I can fantasize if I want to).

Yep, you can.

The other losers are new contributors who get rejected for not
understanding implicit kernel coding styles and people who
get to try to explain to them on a repeating basis (if even
that happens).

or the kernel maintainers if coding style doesn't matter so much
and uglier code begins to be merged.

---
~Randy
