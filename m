Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZDGP4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZDGP4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbZDGP4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:56:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:36830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbZDGP4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:56:33 -0400
Date: Tue, 7 Apr 2009 17:56:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Nico Schottelius <nico-linux-20090330@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Resend] [PATCH] Fix scripts/setlocalversion with git
In-Reply-To: <20090407154437.GA31758@ikn.schottelius.org>
Message-ID: <alpine.LNX.2.00.0904071755540.5327@wotan.suse.de>
References: <20090330122137.GA6918@denkbrett.schottelius.org> <20090407154437.GA31758@ikn.schottelius.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Nico Schottelius wrote:

> Hello again!
> 
> I just saw that this patch did not go anywhere and did not have
> any replies, so I repost it.
> 
> I also created a git-repo at
>   
>   git://git.schottelius.org/linux/linux-2.6
>   gitweb:
>   http://git.schottelius.org/?p=linux/linux-2.6;a=summary
> 
> if you want the patch (f43ba0be1204e7c26cc700a75bdb688a788fbf2f)
> via git.
> 
> Sincerly,
> 
> Nico
> 
> Nico Schottelius [Mon, Mar 30, 2009 at 02:21:37PM +0200]:
> > Hello!
> > 
> > When using trees like wireless-testing, which have untagged tags,
> > scripts/setlocalversion does not display any git indication for
> > localversion.
> > 
> > This patch fixes it: If git is available, but no usable tag is found,
> > it uses -g${head}. It skips the detection of unanottated tags via
> > git name-rev.
> > 
> > Please apply, otherwise testers like me always have '2.6.29' for trees
> > with unanottated tags, instead of 2.6.29-20318-g9aa4755, which helps
> > a lot if you've tons of kernels installed from different trees.

This patch isn't trivial enough to be applicable through trivial tree. 
Adding Sam to CC.

-- 
Jiri Kosina
SUSE Labs
