Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbXK1PRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbXK1PRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbXK1PRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:17:38 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:49851 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752930AbXK1PRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:17:38 -0500
Subject: Re: git guidance
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr>
References: <474C9B31.8000408@imap.cc>
	 <Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 10:15:22 -0500
Message-Id: <1196262922.19921.20.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a project listed on the kernel.org git page called guilt. I
find it very useful. It is much more responsive than stgit and it
actually has a git backend which quilt does not.

git-clone git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git

There is a tutorial associated with guilt which explains the commands
pretty well. The only thing that I find a problem with guilt is
sometimes I forget to pop/push the patches to the right place before
editing them. Actually that is less of a problem with guilt and more of
a problem with me :) Two of the main features that I find very useful
since I track the head of Linus's tree are guilt-rebase and then
guilt-patchbomb for sending patches.

On Wed, 2007-11-28 at 00:20 +0100, Jan Engelhardt wrote:
> On Nov 27 2007 23:33, Tilman Schmidt wrote:
> >
> >It didn't work too well. The first result was one of maximal
> >embarrassment: I produced a patch that didn't even compile when
> >applied to the official tree. This shouldn't happen with git, right?
> >Well, it did. So now I'm back to keeping a virgin kernel source tree
> >alongside my development area in order to produce diffs. That can't
> >be right?
> >
> No, it can't. Use stgit/quilt ;p
> 
> >Does somebody have a step by step tutorial for doing the standard
> >"edit - test - modify - retest - submit - edit - resubmit" sequence
> >with GIT? Is there a GIT newsgroup or mailinglist? Or should I just
> >post my silly questions to LKML?
> >
> http://www.linuxworld.com/video/?bcpid=1138309735&bclid=1213841149&bctid=1221911905
> 
> James Bottomley's intro helps a lot.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

