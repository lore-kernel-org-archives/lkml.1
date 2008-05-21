Return-Path: <linux-kernel-owner+w=401wt.eu-S935611AbYEUNso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935611AbYEUNso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932960AbYEUNse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:48:34 -0400
Received: from mail1.perex.cz ([212.20.107.53]:47991 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763080AbYEUNsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:48:33 -0400
Date: Wed, 21 May 2008 15:48:29 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103-a.perex-int.cz
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Takashi Iwai <tiwai@suse.de>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
In-Reply-To: <48341DF5.4090307@keyaccess.nl>
Message-ID: <Pine.LNX.4.61.0805211517290.1798@tm8103-a.perex-int.cz>
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz>
 <200805211430.06653.linux@audioscience.com> <Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz>
 <s5hve18vtml.wl%tiwai@suse.de> <483415E7.5080402@keyaccess.nl>
 <s5hfxsbx27f.wl%tiwai@suse.de> <48341DF5.4090307@keyaccess.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Rene Herman wrote:

> > > What's the status of that one now? Should I continue pulling that one
> > > or should I switch to the new alsa-kernel GIT repo? I want to pull it
> > > into a Linus clone tree...
> > 
> > We are working on this right now.  alsa.git is far currently behind my
> > tree.
> > 
> > One problem we hit is about multiple committers and rebase.  If you do
> > git-rebase, the commiter information is touched although the sign-off
> > isn't updated.  git-rebase looks apparently designed for the
> > single-commiter model.
> 
> It's "worse" than that; rebasing is designed for a _private_ development 
> model. git-rebase is a very handy tool for people like myself (people 
> without a downstream that is) and it basically enables the quilt model 
> of a stack of patches on top of git but public trees that have people 
> pulling from them should generally not rebase or everyone who _is_ 
> pulling finds a different tree each time.

I don't see big obstacles with this model. You can do changes in your 
local tree and when 'git pull' fails from the subsystem tree, pull new 
subsystem tree to a new branch and do rebasing in your local tree, too.

Rebasing can keep the subsystem tree more clean I think. It's only 
about to settle an appropriate workflow.

					Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

