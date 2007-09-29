Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbXI2UPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbXI2UPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXI2UPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:15:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19482 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXI2UPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:15:34 -0400
Date: Sat, 29 Sep 2007 13:14:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
Message-Id: <20070929131443.536abb94.randy.dunlap@oracle.com>
In-Reply-To: <20070929195638.GA12011@fieldses.org>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
	<alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
	<20070929195638.GA12011@fieldses.org>
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

On Sat, 29 Sep 2007 15:56:38 -0400 J. Bruce Fields wrote:

> On Sat, Sep 29, 2007 at 11:18:05AM -0700, Linus Torvalds wrote:
> > I'm not very happy with this.
> > 
> > "CodingStyle" should be about the big issues, not about details. Yes, 
> > we've messed that up over the years, but let's not continue that.
> > 
> > In other words, I'd suggest *removing* lines from CodingStyle, not adding 
> > them. The file has already gone from a "good general principles" to "lots 
> > of stupid details". Let's not make it worse.
> 
> It'd be nice to split the current CodingStyle into two documents:

I agree.  This is just what I was thinking during lunch.

> 	- A shorter CodingStyle that gives the spirit of the style
> 	  (short functions, minimal nesting, logic as straightforward as
> 	  possible, etc.), and addresses the most commonly repeated
> 	  mistakes, without so much detail that people's eyes glaze
> 	  over.  You want to be able to recommend it to your students
> 	  (or whoever) in reasonable confidence that they'll actually
> 	  read it and have fun (leave the jokes in!).  Currently I'm
> 	  suspicious that it's becoming something that everybody
> 	  recommends but noone bothers to sit down and read anymore
> 	  unless they're working on it.
> 
> 	- A CodingStyleReference that's just a long dry list of rules,
> 	  organized to make it easy to look up an individual rule when
> 	  needed.  That'd also take the pressure of CodingStyle to
> 	  accept every new detail.
> 
> It'd be a start just to revert CodingStyle to its original content and
> move the rest to CodingStyleReference.  But someone would want to skim
> through the CodingStyle history for any legimate corrections that we
> want to keep.

---
~Randy
Phaedrus says that Quality is about caring.
