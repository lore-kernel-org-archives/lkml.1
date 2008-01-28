Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYA1R72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYA1R72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYA1R7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:59:17 -0500
Received: from iabervon.org ([66.92.72.58]:40329 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYA1R7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:59:16 -0500
Date: Mon, 28 Jan 2008 12:59:13 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Gene Heskett <gene.heskett@gmail.com>
cc: Zan Lynx <zlynx@acm.org>, Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <200801281230.32910.gene.heskett@gmail.com>
Message-ID: <alpine.LNX.1.00.0801281248190.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost> <200801281230.32910.gene.heskett@gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Gene Heskett wrote:

> I believe at this point, its moot.  I captured quite a few instances of that 
> error message while rebooting the last time, all of which occurred long 
> before I logged in and did a startx (I boot to runlevel 3 here), so the 
> kernel was NOT tainted at that point.  That dmesg has been posted and some 
> questions asked.
> 
> As this has gone on for a while, it seems to me that with 14,800 google hits 
> on this problem, Linus should call a halt until this is found and fixed.  But 
> I'm not Linus.  I'm also locking up for 30 at a time, & probably ready for 
> reboot #7 today.

Can you switch back to old IDE to get your work done (and to make sure 
it's not a hardware issue that's developed recently)? I believe libata is 
just a whole lot pickier about behavior than the IDE subsystem was, so 
it's more likely to complain about stuff, both for good reasons and when 
it shouldn't, and there are a slew of potential "we have to accept that 
old PATA hardware does this" bugs that all have the same symptom of "we go 
into error handling when nothing is actually wrong", hence the vast 
quantity of hits. I think it's not exactly that it's a common problem as 
that it's a lot of problems that aren't very distinguishable.

	-Daniel
*This .sig left intentionally blank*
