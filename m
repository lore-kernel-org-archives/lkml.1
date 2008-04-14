Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbYDNHgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbYDNHgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYDNHf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:35:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54379 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbYDNHfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:35:55 -0400
To: me@bobcopeland.com
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080414004521.GA30489@hash.localnet> (message from Bob Copeland
	on Sun, 13 Apr 2008 20:45:21 -0400)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <20080414004521.GA30489@hash.localnet>
Message-Id: <E1JlJE6-0004yZ-62@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Apr 2008 09:35:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't feel strongly either way, and Christoph's arguments against
> > fuse are mostly valid (although neither of them are serious).
> 
> I don't have hard numbers, but anecdotally my FUSE version is quite 
> a bit less performant.  That's no criticism of FUSE - I just haven't
> put the time into optimizing and adding various caches.

The worst I/O performance problems should be gone by 2.6.26.
Otherwise there shouldn't be a need to add optimizations to the
userspace code.  The kernel caches take care of that, just like for a
kernel filesystem.

> > There's one thing which makes fuse a slightly better candidate for
> > applications where the number of users is low: stability.  Unless you
> > or your users test the hell out of your filesystem, there always a
> > chance that some bugs will remain.  
> 
> Sure, though this FS won't see the same kind of use as ext2.  Most users
> would just mount it, copy a bunch of files, then unmount it, and if that
> works then great.

Exactly.  Which means, that bugs which happen only in special
circumstances don't surface early and cause more headaches later.

Miklos
