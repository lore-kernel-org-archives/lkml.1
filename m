Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbXFPAk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbXFPAk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbXFPAkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:40:21 -0400
Received: from iabervon.org ([66.92.72.58]:3189 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXFPAkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:40:20 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 20:40:20 EDT
Date: Fri, 15 Jun 2007 20:33:38 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Carlo Wood <carlo@alinoe.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: My kernel hangs again: Help with git please
In-Reply-To: <20070616001255.GA11403@alinoe.com>
Message-ID: <Pine.LNX.4.64.0706152026320.4740@iabervon.org>
References: <20070616001255.GA11403@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007, Carlo Wood wrote:

> Therefore I have the following questions:
> 
> 1) What git command will ASSURE that I get the LATEST
>    kernel tree checked out?
>
> I tried this:
> 
> hikaru:/usr/src/kernel/git/linux-2.6>git branch -l
> * bisect
>   master
>   origin
> hikaru:/usr/src/kernel/git/linux-2.6>git reset --hard HEAD

HEAD doesn't mean what you think it means. It's the latest revision on the 
branch with the *. What you want is:

$ git checkout master

This will move the * to "master", which shouldn't have been affected by 
any of this, and move your working directory to this point as well. At 
that point, you should be able to build a working kernel.

What "git reset --hard HEAD" does is discard any differences to tracked 
files between your working directory and the revision you're on. It's 
relevant if you want to discard local changes, not otherwise.

	-Daniel
*This .sig left intentionally blank*
