Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbXLFS40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbXLFS40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLFS4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:56:17 -0500
Received: from [212.12.190.167] ([212.12.190.167]:33522 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751641AbXLFS4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:56:16 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andreas Ericsson <ae@op5.se>
Subject: Re: git guidance
Date: Fri, 7 Dec 2007 21:55:04 +0300
User-Agent: KMail/1.5
Cc: Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712072035.47359.a1426z@gawab.com> <47583E57.9050208@op5.se>
In-Reply-To: <47583E57.9050208@op5.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712072155.04643.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Ericsson wrote:
> Al Boldi wrote:
> > Phillip Susi wrote:
> >> Al Boldi wrote:
> >>> IOW, git currently only implements the server-side use-case, but fails
> >>> to deliver on the client-side.  By introducing a git-client manager
> >>> that handles the transparency needs of a single user, it should be
> >>> possible to clearly isolate update semantics for both the client and
> >>> the server, each handling their specific use-case.
> >>
> >> Any talk of client or server makes no sense since git does not use a
> >> client/server model.
> >
> > Whether git uses the client/server model or not does not matter; what
> > matters is that there are two distinct use-cases at work here:  one on
> > the server/repository, and the other on the client.
>
> Git is distributed. The repository is everywhere. No server is actually
> needed. Many use one anyway since it can be convenient. It's not, however,
> necessary.

When you read server, don't read it as localized; a server can be 
distributed.  What distinguishes a server from an engine is that it has to 
handle a multi-user use-case.  How that is implemented, locally or remotely 
or distributed, is another issue.

> >> If you wish to use a centralized repository, then
> >> git can be set up to transparently push/pull to/from said repository if
> >> you wish via hooks or cron jobs.
> >
> > Again, this only handles the interface to/from the server/repository,
> > but once you pulled the sources, it leaves you without Version Control
> > on the client.
>
> No, that's CVS, SVN and other centralized scm's. With git you have perfect
> version control on each peer. That's the entire idea behind "fully
> distributed".

As explained before in this thread, replicating the git tree on the client 
still doesn't provide the required transparency.

> > By pulling the sources into a git-client manager mounted on some dir, it
> > should be possible to let the developer work naturally/transparently in
> > a readable/writeable manner, and only require his input when reverting
> > locally or committing to the server/repository.
>
> How is that different from what every SCM, including git, is doing today?
> The user needs to tell the scm when it's time to take a snapshot of the
> current state. Git is distributed though, so committing is usually not the
> same as publishing. Is that lack of a single command to commit and publish
> what's nagging you? If it's not, I completely fail to see what you're
> getting at, unless you've only ever looked at repositories without a
> worktree attached, or you think that git should work like an editor's
> "undo" functionality, which would be quite insane.

You need to re-read the thread.


Thanks!

--
Al

