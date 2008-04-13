Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYDMKiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYDMKiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 06:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYDMKiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 06:38:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34910 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbYDMKiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 06:38:12 -0400
To: hch@infradead.org
CC: akpm@linux-foundation.org, hch@infradead.org, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080413082815.GA20108@infradead.org> (message from Christoph
	Hellwig on Sun, 13 Apr 2008 04:28:15 -0400)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org>
Message-Id: <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 13 Apr 2008 12:37:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not complaining about anything.  Who has?
> > 
> > As the filesystem is for occasional, non-performance-sensitive use
> > by a very small number of people, doing it via FUSE sounds like an
> > all-round more practical approach.  This has nothing to do with quality of
> > implementation at all.
> 
> It's a stupid idea.  Moving a simple block based filesystem means it's
> more complicated, less efficient because of the additional context
> switches and harder to use because you need additional userspace
> packages and need to setup fuse.
> 
> We made writing block based filesystems trivial in the kernel to grow
> more support for filesystems like this one.

I don't feel strongly either way, and Christoph's arguments against
fuse are mostly valid (although neither of them are serious).

There's one thing which makes fuse a slightly better candidate for
applications where the number of users is low: stability.  Unless you
or your users test the hell out of your filesystem, there always a
chance that some bugs will remain.  These rarely bring down the whole
system, but it usually requires a reboot to let you continue using the
Oopsing fs.

Miklos
