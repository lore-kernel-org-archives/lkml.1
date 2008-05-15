Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYEOCk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYEOCk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYEOCkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:40:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbYEOCkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:40:15 -0400
Date: Wed, 14 May 2008 19:40:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Subject: Re: [PULL] v9fs bug fixes and documentation updates for 2.6.26
In-Reply-To: <a4e6962a0805141920x7d96df33gb9c22a5777b1732c@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805141930530.3019@woody.linux-foundation.org>
References: <a4e6962a0805141920x7d96df33gb9c22a5777b1732c@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Eric Van Hensbergen wrote:
> 
> Jim Meyering (1):
>       fs/9p/v9fs.c (v9fs_parse_options): Handle kstrdup and
> match_strdup failure. Now that this function can fail, return an int,
> diagnose other option-parsing failures, and adjust the sole caller:
> (v9fs_session_init): Handle kstrdup failure. Propagate any new
> v9fs_parse_options failure "up".

Grr. Somebody isn't following the nice rules we have and that git 
encourages: make a commit message be a nice "one-line header" with the 
more complete explanation separated by an empty line (and with nice 
line-breaks etc).

IOW, womebody has bad habits from SCM systems that didn't have good 
visualization tools, so likely nobody actually looked at the messages 
anyway.

In fact, looking closer, I don't even know how you did that. The thing 
must have been forwarded as email, because the author is Jim Meyering, but 
it's been forwarded through Andrew etc, so I bet the message was fine at 
some point. And all the git email-application tools do the rigth thing. 

Anyway, I don't *quite* care enough to ask you to re-do this, and I merged 
it, but I do actually enjoy the fact that our commit messages are 
generally pretty readable, and the one-liner header rule means that gitk 
and various shortlog tools all give nice summaries too.

So please look out for this in the future.

There are other commits that don't follow the rules, btw: you've applied 
patches from others that have the rigth Sign-off's from the authors, but 
you should sign off yourself, not just ack them. By actually taking that 
thing and committing it, you're doing more than ack'ing somebody elses 
work.

I know it isn't really a big deal, especially with those things mostly 
being pretty trivial, but I'd rather nip these issues in the bud than have 
it come back when it actually might matter.

			Linus
