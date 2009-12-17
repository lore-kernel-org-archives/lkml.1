Return-Path: <linux-kernel-owner+w=401wt.eu-S1764596AbZLQQjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764596AbZLQQjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764360AbZLQQjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:39:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763312AbZLQQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:39:44 -0500
Date: Thu, 17 Dec 2009 08:39:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2
In-Reply-To: <20091217162454.GA18217@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain>
References: <20091217162454.GA18217@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Al Viro wrote:
>
> Misc bits and pieces, cleaning the table for scaling stuff...
> Please, pull from
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ master
> in a few minutes (or directly from hera)

Btw, would you mind cleaning that repo up?

It has a few very annoying things, the first and foremost of which is that 
HEAD points to some crazy branch (new-truncate). 

So when you do "git pull" without mentioning the branch (which is the 
normal behavior) and would expect to get your default thing (which was 
also what you asked me to pull in your original pull request), you instead 
get some totally inexplicable old random crud.

That's really unexpected for a bare repository. I spent some time looking 
at the odd conflicts the other day when I pulled originally.

I suspect you just did a "scp -rp" or something to initially set it up, 
which is why it contains some random branch - that just happened to be 
your active branch at the time you did that setup.

(It also has FETCH_HEAD, index, COMMIT_EDITMSG etc - all things that don't 
make sense in a bare repository)

			Linus
