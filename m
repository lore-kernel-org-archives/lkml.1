Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZEROJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZEROJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZEROJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:09:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:33943 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEROJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iCIs2V2+LfAiQYo0BeCdX56q8/mqtHl7M/akxAc9Nm57sRqarJwi8f2Zh5N213KGbd
         8BgLJloAIEsjI02I6WzrtwtuyEF0iiyv1gqEI8dIzTh1nw4oDKX0p1Ia+NyqHQMbc2C5
         NxhtGBVY9rSYdH3xWVBdLpr+2fzzF2jUNiXtI=
Date: Mon, 18 May 2009 16:09:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] tracing/stat: cleanups, latency
Message-ID: <20090518140943.GD4704@nowhere>
References: <1242451124-5466-1-git-send-email-fweisbec@gmail.com> <20090518082051.GB10687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518082051.GB10687@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 10:20:51AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > Here are two patches for the stat tracing. I would also like to do 
> > more work on the stat tracing to make it able to manage by itself 
> > the entries for the tracers, ie: the memory allocation, accesses, 
> > locking, releases, etc...
> > 
> > And the workqueue tracer would be a good base to work on it. Then 
> > Ingo, if you pull this, could you please also merge tracing/core 
> > into tracing/workqueue, so that I can continue the work with these 
> > patches and prepare pull requests against tracing/workqueue. It 
> > should be mergeable without conflicts, I just applied the raw 
> > patches from this pull-request into tracing/workqueue and it was 
> > fine.
> 
> sure, i've done that!
> 
> > The following changes since commit 5872144f64b34a5942f6b4acedc90b02de72c58b:
> >   Li Zefan (1):
> >         tracing/filters: fix off-by-one bug
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/core
> > 
> > Frederic Weisbecker (2):
> >       tracing/stat: replace trace_stat_session by stat_session
> >       tracing/stat: replace linked list by an rbtree for sorting
> > 
> >  kernel/trace/trace_stat.c |  166 ++++++++++++++++++++++++++++++--------------
> >  1 files changed, 113 insertions(+), 53 deletions(-)
> 
> Pulled, thanks Frederic.
> 
> Note, i've rebased this on top of the tracing/workqueues topic and 
> have merged both into tip:master. You can use tracing/stat as a Git 
> basis. (assuming it survives today's testing in -tip without 
> requiring a rebase)
> 
> 	Ingo



Ok, thanks!

