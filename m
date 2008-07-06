Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYGFVdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYGFVdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbYGFVdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:33:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40640 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbYGFVdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:33:36 -0400
Date: Sun, 6 Jul 2008 23:34:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux fatal: cannot describe <sha1>
Message-ID: <20080706213424.GA8451@uranus.ravnborg.org>
References: <alpine.LNX.1.10.0807011817230.20393@fbirervta.pbzchgretzou.qr> <20080701200951.GB10677@uranus.ravnborg.org> <20080701221808.GA26272@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701221808.GA26272@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 12:18:08AM +0200, Sebastian Siewior wrote:
> * Sam Ravnborg | 2008-07-01 22:09:51 [+0200]:
> 
> >> Just a note that when you run git-describe, you should probably quiten it.
> >> 
> >> fatal: cannot describe 'bd7364a0fd5a4a2878fe4a224be1b142a4e6698e'
> >> 
> >> This happens when tags are not present, which can happen if Linus's tree 
> >> is sent upwards again, IOW:
> >> 
> >>  machine1$  git-clone torvalds/linux-2.6.git
> >>  machine1$  git push elsewhere master
> >> 
> >>  machine2$  git-clone elsewhere:/linux
> >>  machine2$  git-describe HEAD
> >>  fatal: cannot describe that
> >
> >Hi Jan.
> >
> >Any specific reason why you sent it to me?
> >Maybe because I do not use git describe at all?
> Maybe he was thinking about this (and didn't know that you were moving):
> 
> ---
> scripts: don't desribe if there is nothing to describe

Applied.

	Sam
