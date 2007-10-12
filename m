Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbXJLCJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbXJLCJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXJLCI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:08:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbXJLCI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:08:57 -0400
Date: Thu, 11 Oct 2007 19:08:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] kbuild updates
In-Reply-To: <20071010194434.GA2791@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.999.0710111905420.6887@woody.linux-foundation.org>
References: <20071010194434.GA2791@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Oct 2007, Sam Ravnborg wrote:
> 
> This set of commits are the kbuild stuff that does not
> conflict with the pending x86 merge.

Hmm. It does for me, actually.

I fixed up the trivial conflict in the main Makefile, but that seems to 
leave $(ARCH) entirely undefined in my case, so the end result doesn't 
work. That seems to have nothing to do with my conflict fixup, but is 
something else.

It also gets a trivial conflict with the 'mmc' pull I just did, but that 
didn't seem problematic (mmc added a new case to scripts/mod/file2alias.c, 
and you added a free, both at the end of the same function) - but the x86 
merge conflict means that I decided that I'll let you sort it out. It's 
probably really trivial, but I'll merge the other stuff I have pending 
instead.

		Linus
