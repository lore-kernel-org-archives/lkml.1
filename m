Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbZERR33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbZERR33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZERR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:29:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbZERR3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:29:21 -0400
Date: Mon, 18 May 2009 10:28:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Mahoney <jeffm@suse.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 4/4] reiserfs: allow exposing privroot w/ xattrs
 enabled
In-Reply-To: <alpine.LFD.2.01.0905171009200.3301@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905181026560.3301@localhost.localdomain>
References: <20090517050200.786752018@suse.com> <20090517050332.566856122@suse.com> <alpine.LFD.2.01.0905171009200.3301@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 May 2009, Linus Torvalds wrote:
> 
> 
> On Sun, 17 May 2009, Jeff Mahoney wrote:
> >
> > --- a/fs/reiserfs/dir.c
> > +++ b/fs/reiserfs/dir.c
> 
> Hmm. This had no explanation or sign-off. Please? At least the sign-off, 
> but I think I'd like a log message too, since this adds a new mount option 
> etc, so it's not like this is some trivial one-liner that doesn't need it.

Jeff, ping?

I merged the other three patches, but this one is still pending. I'm not 
entirely sure it's even appropriate for 2.6.30 (it doesn't _look_ like 
it's fixing any regressions), but even if you don't actually want me to 
merge it, can you say so? And if you do want me to merge it, I want the 
sign-off and fuller log message..

		Linus
