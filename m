Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYKNDaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYKNDaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYKNDao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:30:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:59259 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYKNDan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:30:43 -0500
Date: Fri, 14 Nov 2008 04:30:41 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081114033041.GD24414@wotan.suse.de>
References: <20081113072821.GB2946@wotan.suse.de> <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org> <20081114015817.GC5063@wotan.suse.de> <alpine.LFD.2.00.0811131803300.3468@nehalem.linux-foundation.org> <20081114024347.GB24414@wotan.suse.de> <alpine.LFD.2.00.0811131916530.3468@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811131916530.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 07:18:11PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 14 Nov 2008, Nick Piggin wrote:
> > 
> > I don't exactly know what you mean by random micro-optimization. It is
> > what it is. I like counting cachelines and branches and I thought you
> > did as well.
> 
> You're missing the point.
> 
> If you spent a bit more time on it, it would be a cleanup too, and we 
> wouldn't need this discussion.

> As it is, it's a wash. At which point I'd simply rather not touch the 
> code. 
> 
> You can have your cake and eat it too, and I tried to explain how. And I 
> don't understand why you argue against it.

Oh OK. I am going to add those changes that you suggested (in fact, I
already have). I just thought for some reason you wanted it to make
further cleanups or something.

I wasn't arguing against that. Or against refactoring the code in as
clean a way possible if there is any refactoring happening at all for
any reason (eg. performance or functionality as the primary reason).
I just wasn't going to repost the patch because as I said, my level of
testing and the relative urgency of it wouldn't justify it.
