Return-Path: <linux-kernel-owner+w=401wt.eu-S1423181AbXBBHWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423181AbXBBHWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423180AbXBBHV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:21:56 -0500
Received: from mx1.suse.de ([195.135.220.2]:44773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423173AbXBBHVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:21:34 -0500
Date: Fri, 2 Feb 2007 08:21:33 +0100
From: Nick Piggin <npiggin@suse.de>
To: Neil Brown <neilb@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: half-fix page tail zeroing on write problem
Message-ID: <20070202072133.GA26431@wotan.suse.de>
References: <20070202055142.GA5004@wotan.suse.de> <17858.55858.642522.861130@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17858.55858.642522.861130@notabene.brown>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 05:29:06PM +1100, Neil Brown wrote:
> On Friday February 2, npiggin@suse.de wrote:
> > Hi,
> > 
> > For no important reason, I've again looked at those zeroing patches that
> > Neil did a while back. I've always thought that a simple
> > `write(fd, NULL, size)` would cause the same sorts of problems.
> 
> Yeh, but who in their right mind would do that???
> Oh, you did :-)

Well that's the test-case. Obviously not many people do it, but that's
all the more reason to be careful about correct behaviour.

> I cannot see why you make a change to fault_in_pages_writeable.  Is it
> just for symmetry?

Yes.

> For the rest, it certainly makes sense to return an early -EFAULT if
> you cannot fault in the page.

I think so.

Thanks,
Nick
