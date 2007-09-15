Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXIOWrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXIOWrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 18:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXIOWr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 18:47:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbXIOWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 18:47:25 -0400
Date: Sat, 15 Sep 2007 15:47:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
In-Reply-To: <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
 <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com>
 <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Sep 2007, Linus Torvalds wrote:
> 
> So regardless of whether we want to trust "user_mode(regs)" more than 
> "error_code & PF_USER", it would definitely be very interesting if you can 
> give a good "this is where it started happening".

Also, can you point to good crashme sources, and give the arguments you 
used to run it when it crashed?

The original gjc crashme doesn't even do a "mprotect(PROT_EXEC)" by 
default (nor does it even compile on a modern unix), so it's not going to 
do anything. I hacked it up, and it appears to work ok for me, but I'm not 
at all confident that I'm even close to recreating what you are doing.

(It probably goes without saying that I've not reproduced the oops on my 
Core 2 Duo. Lots of #GP and #PF errors, but nothing interesting.

		Linus
