Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYDNAqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYDNAqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYDNAqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:46:42 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:57973 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbYDNAqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:46:42 -0400
Date: Sun, 13 Apr 2008 20:45:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080414004521.GA30489@hash.localnet>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 12:37:31PM +0200, Miklos Szeredi wrote:
> I don't feel strongly either way, and Christoph's arguments against
> fuse are mostly valid (although neither of them are serious).

I don't have hard numbers, but anecdotally my FUSE version is quite 
a bit less performant.  That's no criticism of FUSE - I just haven't
put the time into optimizing and adding various caches.

> There's one thing which makes fuse a slightly better candidate for
> applications where the number of users is low: stability.  Unless you
> or your users test the hell out of your filesystem, there always a
> chance that some bugs will remain.  

Sure, though this FS won't see the same kind of use as ext2.  Most users
would just mount it, copy a bunch of files, then unmount it, and if that
works then great.

It has at least seen some testing with fsx, though I had to turn off most 
of the checks since growing truncate is still unimplemented.  

-- 
Bob Copeland %% www.bobcopeland.com 

