Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbXJLEPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbXJLEPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXJLEPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:15:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55344 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbXJLEPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:15:23 -0400
Date: Fri, 12 Oct 2007 06:16:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] kbuild updates
Message-ID: <20071012041653.GA16142@uranus.ravnborg.org>
References: <20071010194434.GA2791@uranus.ravnborg.org> <alpine.LFD.0.999.0710111905420.6887@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710111905420.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 07:08:53PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 10 Oct 2007, Sam Ravnborg wrote:
> > 
> > This set of commits are the kbuild stuff that does not
> > conflict with the pending x86 merge.
> 
> Hmm. It does for me, actually.
I did not try it out obviously - I just removed everything touching x86_64/i386.
This is the SRCARCH changes in top-level Makefile.

> 
> I fixed up the trivial conflict in the main Makefile, but that seems to 
> leave $(ARCH) entirely undefined in my case, so the end result doesn't 
> work. That seems to have nothing to do with my conflict fixup, but is 
> something else.
> 
> It also gets a trivial conflict with the 'mmc' pull I just did, but that 
> didn't seem problematic (mmc added a new case to scripts/mod/file2alias.c, 
> and you added a free, both at the end of the same function) - but the x86 
> merge conflict means that I decided that I'll let you sort it out. It's 
> probably really trivial, but I'll merge the other stuff I have pending 
> instead.

As Andrew has an issue with my geneius "save ARCH & CROSS_COMPILE" patch
this is perfect. I will sort out the conflicts and Andrew's use-case and
submit a new pull request.

	Sam
