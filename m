Return-Path: <linux-kernel-owner+w=401wt.eu-S1764991AbXEYUle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764991AbXEYUle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbXEYUl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:41:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40925 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbXEYUl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:41:28 -0400
Date: Fri, 25 May 2007 21:41:27 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: double exclamation (!!) suckage in the kernel
Message-ID: <20070525204127.GK4095@ftp.linux.org.uk>
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 01:53:59AM +0530, Satyam Sharma wrote:
> Hello,
> 
> Grepping through the sources I found 500+ occurrences of double
> exclamation marks before identifier names (such as !!x -- I took care
> to ignore occurrences of !! inside comment blocks, because there
> are plenty of that sort too).
> 
> !! are to be found even in the definitions of common macros such as
> likely() and unlikely(), which hundreds of eyes must have seen over
> the last year or so ...
> 
> Are all these occurrences merely the debris of
> s/something/!notsomething/g kind of patches or is there some
> dark, unknown C / gcc wizardry I have absolutely no clue of?

That's a question for a quiz in introductory course on C:
	what type should x have for !!x to be a valid expression?
	what will be the type of result?
	what are the possible values of the result?
	describe which values of x correspond to each possible value of !!x

You have 10 minutes (and that's a fairly generous, actually).
