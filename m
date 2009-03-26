Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZCZIaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZCZIaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZCZI3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:29:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57577 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZCZI3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:29:42 -0400
Date: Thu, 26 Mar 2009 09:29:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
Message-ID: <20090326082939.GF27476@kernel.dk>
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu> <20090325101747.GL27476@kernel.dk> <49CAE4CB.3050000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CAE4CB.3050000@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26 2009, Li Zefan wrote:
> Jens Axboe wrote:
> > On Wed, Mar 25 2009, Ingo Molnar wrote:
> >> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> >>
> >>> Currently the original blktrace, which is using relay and is used 
> >>> via ioctl, is broken. You can use ftrace to see the output of 
> >>> blktrace, but user-space blktrace is unusable.
> >> good catch, thanks Li!
> >>
> >> Jens, Arnaldo, do these fixes look good to you too?
> > 
> > Look fine, but I'm very worried about the state of the current code. I
> > mean, this last round of fixes got the timestamp correct and made
> > blktrace work again. Those are something that should have been caught
> > even before the whole thing was posted, let alone merged. When do you
> > plan on pushing this upstream? Looks like 2.6.31 to me, it's clearly not
> > ready for 2.6.30 by any stretch.
> > 
> 
> Actually not all the bugs I found are introduced by "blktrace: ftrace plugin"
> in -tip tree.

Oh sure, I did see that! And the fixes are appreciated of course.

> One is introduced by "block: get rid of the manual directory counting in blktrace"
> (f48fc4d32e24c0b6a18aad30305d819bcc68c049). Two are "blktrace: port to tracepoints"
> (5f3ea37c7716db4e894a480e0c18b24399595b6b). Both commits are in mainline.
> 
> Since 2 of the bugs will rarely happen in real-life, and the 3rd one
> is a small issue, and we were so close to the release of .29, so I
> sent the fixes for -tip tree but not mainline. But if we are going
> merge tip/blktrace to .31, I guess it's better to merge that 3 fixes
> to .30?

Since you are the person that worked on it most lately, your opinion
matters the most. What do you think, is it ready for 2.6.30 or should it
wait for .31?

-- 
Jens Axboe

