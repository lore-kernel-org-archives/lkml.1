Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYBRLsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYBRLsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYBRLsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:48:13 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50586 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993AbYBRLsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:48:12 -0500
To: hch@infradead.org
CC: akpm@linux-foundation.org, hch@infradead.org, miklos@szeredi.hu,
       serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, haveblue@us.ibm.com,
       viro@ZenIV.linux.org.uk
In-reply-to: <20080215091438.GA24386@infradead.org> (message from Christoph
	Hellwig on Fri, 15 Feb 2008 04:14:38 -0500)
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall
	(v8)
References: <20080205213616.343721693@szeredi.hu> <20080214222103.a5d8f4fe.akpm@linux-foundation.org> <20080215090120.GA6266@infradead.org> <20080215010951.163fe10e.akpm@linux-foundation.org> <20080215091438.GA24386@infradead.org>
Message-Id: <E1JR4TX-000392-Cu@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Feb 2008 12:47:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > However David and Christoph are beavering away on the r-o-bind-mounts
> > > > patches and I expect that there will be overlaps with unprivileged mounts.
> > > > 
> > > > Could we coordinate things a bit please?  Decide who goes first, review
> > > > and maybe even test each others work, etc?
> > > 
> > > Al is setting up a git tree for VFS work.  per-mount r/o will go in
> > > as one of the first things, aswell as his rework of the path lookup
> > > logic to fix the intents mess.
> > > 
> > 
> > That didn't answer my question..
> 
> Well, Al as the defacto VFS maintainer will decide on the ordering.

I think we agreed, that r-o-bind mounts are more important, so they
should go first.  They have also received more attention.  OTOH there
isn't really any fundamental conflict between the two patchsets, so
going in together (if the ro-bind patches miss 2.6.25) should also be
possible.

> Reviewing this stuff properly is still on my todo list, but currently
> I'm busy with more important things.

So what should I do?

Would Al be wanting to merge this into his VFS tree?  (Can't find it
on git.kernel.org yet, BTW.)  I can set up a git tree for these
patches if that makes things easier.

Or should I just wait and resubmit after every kernel release, hoping
that it becomes _the_ most important thing on Christoph's list ;)

Miklos
