Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYBWFER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYBWFER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 00:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYBWFD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 00:03:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60907 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYBWFD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 00:03:56 -0500
Message-ID: <47BFA938.3050504@garzik.org>
Date: Sat, 23 Feb 2008 00:03:52 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
CC: Chase Venters <chase.venters@clientec.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: Question about your git habits
References: <200802221837.37680.chase.venters@clientec.com> <alpine.LNX.1.00.0802222249480.19024@iabervon.org>
In-Reply-To: <alpine.LNX.1.00.0802222249480.19024@iabervon.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
> I find that the sequence of changes I make is pretty much unrelated to the 
> sequence of changes that end up in the project's history, because my 
> changes as I make them involve writing a lot of stubs (so I can build) and 
> then filling them out. It's beneficial to have version control on this so 
> that, if I screw up filling out a stub, I can get back to where I was.
> 
> Having made a complete series, I then generate a new series of commits, 
> each of which does one thing, without any bugs that I've resolved, such 
> that the net result is the end of the messy history, except with any 
> debugging or useless stuff skipped. It's this series that gets merged into 
> the project history, and I discard the other history.
> 
> The real trick is that the early patches in a lot of series often refactor 
> existing code in ways that are generally good and necessary for your 
> eventual outcome, but which you'd never think of until you've written more 
> of the series.

That summarizes well how I do original development, too.  Whether its a 
branch of an existing repo, or a newly cloned repo, when working on new 
code I will do a first pass, committing as I go to provide useful 
checkpoints.

Once I reach a satisfactory state, I'll refactor the patches so that 
they make sense for upstream submission.

	Jeff


