Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYEFKdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYEFKdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 06:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYEFKdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 06:33:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44875 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYEFKdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 06:33:24 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080506091632.GA28032@infradead.org> (message from Christoph
	Hellwig on Tue, 6 May 2008 05:16:32 -0400)
Subject: Re: [patch 00/24] vfs: fixes and cleanups + add helpers to check
	r/o bind mounts
References: <20080506091327.259950960@szeredi.hu> <20080506091632.GA28032@infradead.org>
Message-Id: <E1JtKTz-0001BC-BO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 May 2008 12:33:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Here it is again as a single series (without the ecryptfs one already
> > merged).
> > 
> > I've addressed Christoph's comments.
> 
> And totally ignored Al's while merging the second rejected series into
> the first one.

Al doesn't like it but everybody else does.  His excuses are very
hollow and hypocritical, just take this for example: "Except that it
fixes nothing in nfsd, as we'd already figured out".  That's after
discussing extensively how racy the current nfsd code is.  And even
then the only acknowledgement I get is that the code has always been
racy.  You bet it has been bloody racy, that's what the r-o-bind
patches are supposed to fix.

All through that tread, I got a barrage of nasties thrown at me, and
every time it turned out that I was right.  And then just that issue
disappears from the next reply.  No "sorry about that, you were
right".  Yes, I'm getting tired from Al's attitude towards this thing,
and as long as no better patches from him or anybody else are
forthcoming, or comments actually addressing the _patches_ themselves,
instead of some hypothetical users of these interfaces, I'm just going
to ignore Al's rejections outright.

Now I have much respect for work he has and is doing on the kernel,
make no mistake.  But that doesn't make him somebody who can reject
patches on a whim.

> I also still want to go over the various setattr-related changes,
> pleawse give me some time for those.

Sure, and thanks for looking at the patches.

Miklos
