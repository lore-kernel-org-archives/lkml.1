Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbXJUBs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbXJUBs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXJUBsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:48:20 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43304 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXJUBsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:48:19 -0400
Date: Sat, 20 Oct 2007 19:05:27 -0400
Message-Id: <200710202305.l9KN5R0i008618@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: Re: what to call it after 2.6.23 but before 2.6.24-rc1? 
In-reply-to: Your message of "Sat, 20 Oct 2007 15:26:45 PDT."
             <alpine.LFD.0.999.0710201517530.10525@woody.linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <alpine.LFD.0.999.0710201517530.10525@woody.linux-foundation.org>, Linus Torvalds writes:

> On Sat, 20 Oct 2007, Erez Zadok wrote:
[...]

>  - if you are a git user, and got it that way, just use the git name, and 
>    use "git describe" to get it.
> 
>    So my current head is called "v2.6.23-6562-g8add244" which tells you 
>    three things:
>      (a) it's based on 2.6.23
>      (b) there's been 6562 commits since 2.6.23
>      (c) the top-of-tree abbreviated commit is "8add244".

Bingo.  git-describe is what I was looking for.  It's more accurate to use
as a reference even after rcN come out.  My current cloned tree of yours
sez:

	v2.6.23-6562-g8add244

One more small git question: I keep a separate tree for unionfs, which I
rebase often based on your tree.  But my tree sez:

$ git-describe
v2.6.21-rc1-22880-g3a1848d

"v2.6.21-rc1"?  What am I missing (some tags I forgot to pull?)  Why isn't
git-describe saying that I'm based on your latest tree?

Thanks,
Erez.
