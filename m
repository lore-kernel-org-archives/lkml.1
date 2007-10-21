Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbXJUBex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbXJUBex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbXJUBes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:34:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbXJUBer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:34:47 -0400
Date: Sat, 20 Oct 2007 17:37:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: what to call it after 2.6.23 but before 2.6.24-rc1? 
In-Reply-To: <200710202305.l9KN5R0i008618@agora.fsl.cs.sunysb.edu>
Message-ID: <alpine.LFD.0.999.0710201732300.10525@woody.linux-foundation.org>
References: <200710202305.l9KN5R0i008618@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Erez Zadok wrote:
>
> One more small git question: I keep a separate tree for unionfs, which I
> rebase often based on your tree.  But my tree sez:
> 
> $ git-describe
> v2.6.21-rc1-22880-g3a1848d
> 
> "v2.6.21-rc1"?  What am I missing (some tags I forgot to pull?)  Why isn't
> git-describe saying that I'm based on your latest tree?

Sounds like you don't have the tags. Do

	git fetch --tags <repo> 

to get them.

There can be several reasons why you don't have the tags, but the two most 
likely ones are:

 - really old versions of git didn't fetch tags by default.

   (not very likely, because it's *really* old, but still, worth 
   mentioning as one possible reason)

 - if you don't fetch into a "tracking" branch, but instead do an 
   "anonymous" fetch into FETCH_HEAD that is then directly merged (or you 
   just rebase your work on top of it), git won't fetch tags, since it 
   assumes that you only want to fetch the one head you mentioned.

but regardless, you can always fetch the tags manually.

		Linus
