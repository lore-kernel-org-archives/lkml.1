Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYJXXQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYJXXQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbYJXXPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:15:40 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:38204 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbYJXXPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:15:39 -0400
Date: Fri, 24 Oct 2008 21:22:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc1
Message-ID: <20081024192241.GA17080@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk> <200810241345.04966.rjw@sisk.pl> <200810241352.45745.alistair@devzero.co.uk> <alpine.LFD.2.00.0810240801540.3287@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810240801540.3287@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 08:17:53AM -0700, Linus Torvalds wrote:
> 
> You can use "git clean -dfx" to force git to remove ignored files too. And 
> "make distclean" should have done it too.

I just checked and make mrproper / make distclean deletes the symlink
as expected.

> Now, _another_ part (and arguably the really core reason) of this problem 
> is that our Makefile rules for the asm include directory is weak and 
> unreliable in the presense of already-existing unexpected entries.
> 
> And it has caused problems before. For example, if you somehow made the 
> symlink not be a symlink at all (by using "cp -LR" for example), or a 
> symlink pointing to another architecture (changing architecture builds in 
> the same tree without doing a "make clean" in between), you historically 
> got really odd results.

We do not cover the "asm symlink became a dir" problem.
But when all archs has moved headers it is anyway implicitly covered.

	Sam
