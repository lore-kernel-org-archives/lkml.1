Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbXI2T4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbXI2T4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXI2T4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:56:45 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57976 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbXI2T4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:56:44 -0400
Date: Sat, 29 Sep 2007 15:56:38 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
Message-ID: <20070929195638.GA12011@fieldses.org>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 11:18:05AM -0700, Linus Torvalds wrote:
> I'm not very happy with this.
> 
> "CodingStyle" should be about the big issues, not about details. Yes, 
> we've messed that up over the years, but let's not continue that.
> 
> In other words, I'd suggest *removing* lines from CodingStyle, not adding 
> them. The file has already gone from a "good general principles" to "lots 
> of stupid details". Let's not make it worse.

It'd be nice to split the current CodingStyle into two documents:

	- A shorter CodingStyle that gives the spirit of the style
	  (short functions, minimal nesting, logic as straightforward as
	  possible, etc.), and addresses the most commonly repeated
	  mistakes, without so much detail that people's eyes glaze
	  over.  You want to be able to recommend it to your students
	  (or whoever) in reasonable confidence that they'll actually
	  read it and have fun (leave the jokes in!).  Currently I'm
	  suspicious that it's becoming something that everybody
	  recommends but noone bothers to sit down and read anymore
	  unless they're working on it.

	- A CodingStyleReference that's just a long dry list of rules,
	  organized to make it easy to look up an individual rule when
	  needed.  That'd also take the pressure of CodingStyle to
	  accept every new detail.

It'd be a start just to revert CodingStyle to its original content and
move the rest to CodingStyleReference.  But someone would want to skim
through the CodingStyle history for any legimate corrections that we
want to keep.

--b.
