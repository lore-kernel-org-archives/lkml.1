Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbXIUPEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbXIUPEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbXIUPEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:04:35 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55589 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757803AbXIUPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:04:34 -0400
Date: Fri, 21 Sep 2007 17:04:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Peter Stahlir <peter.stahlir@googlemail.com>
Cc: Muhammad Tayyab <mail.tayyab@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Git as a filesystem
Message-ID: <20070921150449.GE13255@stusta.de>
References: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com> <46F3AAC1.5050409@gmail.com> <fbe8b1780709210437s18b24945jab5a3ffa07646427@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fbe8b1780709210437s18b24945jab5a3ffa07646427@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 01:37:33PM +0200, Peter Stahlir wrote:
> > Peter Stahlir wrote:
> > > Hi!
> > >
> > > Is it possible/feasible to use git as a filesystem?
> > > Like having git on top of ext3.
> > >
> > > This way I could do a gitfs-gc and there is only one
> > > pack file sitting on the disk which is a compressed
> > > version of the whole system.
> > > I am not interested in a version controlled filesystem,
> > > only in the space saving aspects.
> 
> 
> 2007/9/21, Muhammad Tayyab <mail.tayyab@gmail.com>:
> > Hi,
> >    I think it would be a bad idea to use Git as a part of filesystem. If
> > someone wants to install it and use it, its his choice, but if we make
> > it the part of Filesystem, and just use it for compression, this will
> > reduce the performance.
> >    For compression, i think more preferable is to make a patch for ext3
> > that implements the compression, like compression patch for ext2.
> 
> As I understand it the compression patches for ext2 only compress
> a single file. I think gitfs would compress much better because it
> deltifies between all files. So if you are not interested in
> performance but space
> efficiency a gitfs would be nice.

git is kewl, so it must be the solution for all problems?

git keeps information of all versions of a file.
This can by definition not be smaller than only storing the current 
version.

And git doesn't perform any magic, it uses the zlib library that is 
neither unusual nor the best compression method available.

> Peter
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

