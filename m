Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYLKIHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYLKIHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYLKIHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:07:04 -0500
Received: from 1wt.eu ([62.212.114.60]:1654 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbYLKIHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:07:03 -0500
Date: Thu, 11 Dec 2008 09:06:27 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211080627.GA31552@1wt.eu>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 05:04:39PM -0800, Linus Torvalds wrote:
> 
> Nothing overly exciting here. Lots of small things, mostly in drivers 
> (with some defconfig updates for m68k and mips making the diffs bigger). 
> 
> There's some uncomfortably big changes to the intel DRI code, but most of 
> that is all about fixes to the new i916 "GEM" code that is only used by 
> development X servers, and is a new feature, so it shouldn't be able to 
> cause regressions.
> 
> Perhaps more interesting is simply the release scheduling issue. I'm 
> getting slowly ready to do a real 2.6.28, but I don't think anybody really 
> wants the merge window to be around the holidays. So the question is 
> really whether to 
> 
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> 
>      I like this, because alledgely people are debugging things, and we'd 
>      get a more stable 2.6.28.
> 
> or
> 
>  (b) release in a week or two, but just allow for possibly extending the 
>      merge window due to people being drunk on eggnog..
> 
>      I like this because let's face it, we get more and better bug 
>      information after releases, and everything _should_ be ready for 
>      merging *before* the merge window anyway.
> 
> or
> 
>  (c) some other crazy scheme that somebody comes up with in a drug-induced 
>      stupor.
> 
> So I haven't quite decided on that thing yet, but I'm open to suggestions. 

I'd suggest :
   (c) release before holidays, and not extend merge window. That way,
       users can test it during holidays, and we possibly merge less
       things this time, leading to less changes and more focus on fixes
       in 2.6.29, which I admit may imply more crap in 2.6.30. But that
       could give a high quality 2.6.29 by spring.

Just my 2 cents,
Willy

