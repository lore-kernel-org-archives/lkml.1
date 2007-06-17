Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbXFQKwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbXFQKwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXFQKwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 06:52:30 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:46735 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbXFQKw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 06:52:29 -0400
Date: Sun, 17 Jun 2007 12:52:27 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Carlo Wood <carlo@alinoe.com>, Daniel Barkalow <barkalow@iabervon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: My kernel hangs again: Help with git please
Message-ID: <20070617105226.GA22912@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Carlo Wood <carlo@alinoe.com>,
	Daniel Barkalow <barkalow@iabervon.org>,
	linux-kernel@vger.kernel.org
References: <20070616001255.GA11403@alinoe.com> <Pine.LNX.4.64.0706152026320.4740@iabervon.org> <20070616040747.GA21076@alinoe.com> <Pine.LNX.4.64.0706160059210.4740@iabervon.org> <20070616140340.GA30861@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070616140340.GA30861@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3CcuQaFzAcmG5c=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood, Sat, Jun 16, 2007 16:03:40 +0200:
> $ git merge origin
> fatal: Needed a single revision
> Usage: /usr/bin/git-merge [-n] [--no-commit] [--squash] [-s <strategy>]... <merge-message> <head> <remote>+
> 
> For some reason I don't think I should be needing commands that need
> "<merge-message>"; I don't want to change the (local) tree in anyway.

I'd recommend to upgrade your git. There are some really nice
improvements in the latest versions (1.5.2.2, for instance).
Particularly, the command above would have worked. That is, assuming
you actually do have that origin branch. In any case, a

    $ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git master
    $ git reset --hard FETCH_HEAD

will get you the very latest kernel in your working directory. Has
some disadvantages, though: does not retrieve the tags and destroys
local changes.

But you'll find a man page of git-remote and git-config very
interesting, especially wrt the above operation. I do just "git pull",
for example and actually _am_ sure I get the latest kernel, get all
the tags and never loose local changes.

