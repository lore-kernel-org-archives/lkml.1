Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbXKOFx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbXKOFx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 00:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbXKOFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 00:53:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbXKOFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 00:53:47 -0500
Date: Wed, 14 Nov 2007 21:53:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org>
 <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net> <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
 <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Nov 2007, Linus Torvalds wrote:
> 
> So even at 100% dirty limits, it won't let you dirty more than 1GB on the 
> default 32-bit setup.

Side note: all of these are obviously still just heuristics. If you really 
*do* run on a 32-bit kernel, and you want to have the pain, I'm sure you 
can just disable the dirty limits with a one-liner kernel mod. And if it's 
useful enough, we can certainly expose flags like that.. Not that I expect 
that much anybody else will ever care, but it's not like it's wrong to 
expose the silly heuristics the kernel has to users that have very 
specific loads.

That said, I still do hope you aren't actually using HIGHMEM64G. I was 
really hoping that the people who had enough moolah to buy >4GB of RAM had 
long since also upgraded to a 64-bit machine ;)

		Linus
