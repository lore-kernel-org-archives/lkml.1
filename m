Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXEZJbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXEZJbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 05:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbXEZJbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 05:31:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4887 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753374AbXEZJbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 05:31:15 -0400
Date: Thu, 24 May 2007 12:07:32 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070524120731.GC7444@ucw.cz>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > As for unlink...  How do you deal with having that thing
> > mounted, mounting something _under_ it (so that vfsmount would be kept
> > busy) and then unlinking that sucker?
> 
> Yeah, that's a good point.  Current patch doesn't deal with that.
> Simplest solution could be to disallow submounting these.  Don't think
> it makes much sense anyway.

Hmmm, cd foo.tgz/bar/baz.tgz/xyzzy makes sense, and it is implemented
as a submount, no?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
