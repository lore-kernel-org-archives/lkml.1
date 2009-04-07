Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbZDGRn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbZDGRn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZDGRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:43:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54072 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbZDGRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:43:46 -0400
Date: Tue, 7 Apr 2009 19:45:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nico Schottelius <nico-linux-20090330@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [Resend] [PATCH] Fix scripts/setlocalversion with git
Message-ID: <20090407174550.GB13089@uranus.ravnborg.org>
References: <20090330122137.GA6918@denkbrett.schottelius.org> <20090407154437.GA31758@ikn.schottelius.org> <alpine.LNX.2.00.0904071755540.5327@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0904071755540.5327@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 05:56:31PM +0200, Jiri Kosina wrote:
> On Tue, 7 Apr 2009, Nico Schottelius wrote:
> 
> > Hello again!
> > 
> > I just saw that this patch did not go anywhere and did not have
> > any replies, so I repost it.
> > 
> > I also created a git-repo at
> >   
> >   git://git.schottelius.org/linux/linux-2.6
> >   gitweb:
> >   http://git.schottelius.org/?p=linux/linux-2.6;a=summary
> > 
> > if you want the patch (f43ba0be1204e7c26cc700a75bdb688a788fbf2f)
> > via git.
> > 
> > Sincerly,
> > 
> > Nico
> > 
> > Nico Schottelius [Mon, Mar 30, 2009 at 02:21:37PM +0200]:
> > > Hello!
> > > 
> > > When using trees like wireless-testing, which have untagged tags,
> > > scripts/setlocalversion does not display any git indication for
> > > localversion.
> > > 
> > > This patch fixes it: If git is available, but no usable tag is found,
> > > it uses -g${head}. It skips the detection of unanottated tags via
> > > git name-rev.
> > > 
> > > Please apply, otherwise testers like me always have '2.6.29' for trees
> > > with unanottated tags, instead of 2.6.29-20318-g9aa4755, which helps
> > > a lot if you've tons of kernels installed from different trees.
> 
> This patch isn't trivial enough to be applicable through trivial tree. 
> Adding Sam to CC.

Thanks. Will take care later this week.

	Sam
