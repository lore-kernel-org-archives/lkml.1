Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbXJUBiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbXJUBiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbXJUBh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:37:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbXJUBh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:37:57 -0400
Date: Sat, 20 Oct 2007 15:26:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: what to call it after 2.6.23 but before 2.6.24-rc1?
In-Reply-To: <200710202154.l9KLsZoF005751@agora.fsl.cs.sunysb.edu>
Message-ID: <alpine.LFD.0.999.0710201517530.10525@woody.linux-foundation.org>
References: <200710202154.l9KLsZoF005751@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Erez Zadok wrote:
>
> Linus, is there a preferred name to refer to the kernel version in your tree
> after 2.6.23 is out (and the official 2.6.23.y git was created) but before
> you release 2.6.24-rc1?

Well, since you can only get one of those kernels in two ways, there's a 
very unambiguous naming policy.

 - if you got one of the nightly snapshots, name it by the snapshot name 
   (I still call them "nightly snapshots", but they do in fact happen 
   twice a day if there have been changes, so that's not technically 
   correct)

   So the last snapshot would be linux-2.6.23-git15

   This is an exact name, because you can go to kernel.org and look up the 
   exact commit ID that was used to generate it (there's an "ID" file 
   associated with each snapshot there).

   For bonus points, if you report a bug against such a snapshot, look up 
   the ID yourself, so that others don't have to do that..

 - if you are a git user, and got it that way, just use the git name, and 
   use "git describe" to get it.

   So my current head is called "v2.6.23-6562-g8add244" which tells you 
   three things:
     (a) it's based on 2.6.23
     (b) there's been 6562 commits since 2.6.23
     (c) the top-of-tree abbreviated commit is "8add244".

> I've seen online references to it as "2.6.24", "2.6.24++", "2.6.24-rc0", 
> etc.

Yeah, please don't use those names. They don't actually tell anything 
about where in the cycle it is, and as you can see above, there's been 
6500+ commits since 2.6.23, so saying "2.6.23-rc0" or similar really isn't 
very helpful if anybody actually cares about just where in the release 
cycle you are.

			Linus
