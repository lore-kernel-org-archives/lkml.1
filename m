Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYJML4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYJML4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYJML41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:56:27 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:49099 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbYJML41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:56:27 -0400
Date: Mon, 13 Oct 2008 14:07:19 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bodo Eggert <7eggert@gmx.de>, Adam Tla__ka <atlka@pg.gda.pl>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
In-Reply-To: <20081013110125.5e3e5fa6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LSU.0.999.0810131359310.6408@be1.lrz>
References: <bjXel-4CU-17@gated-at.bofh.it> <bjYap-5Q0-25@gated-at.bofh.it>
 <bk30i-3Gx-1@gated-at.bofh.it> <bk6AV-8ms-7@gated-at.bofh.it>
 <bkrvO-1HF-49@gated-at.bofh.it> <blePJ-6rI-3@gated-at.bofh.it>
 <blmDC-7ZU-7@gated-at.bofh.it> <E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
 <20081011185821.0dab4c81@lxorguk.ukuu.org.uk> <20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
 <20081012152200.4a8f14c4@lxorguk.ukuu.org.uk> <20081012195957.50feada3@merlin.oi.pg.gda.pl>
 <20081012190312.0bd04ab8@lxorguk.ukuu.org.uk> <20081012210140.15cecf78@merlin.oi.pg.gda.pl>
 <20081012212244.117852e0@lxorguk.ukuu.org.uk> <alpine.LSU.0.999.0810131155280.5750@be1.lrz>
 <20081013110125.5e3e5fa6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Alan Cox wrote:
> Bodo Eggert <7eggert@gmx.de> wrote:
> > On Sun, 12 Oct 2008, Alan Cox wrote:

> > > > That is why I propose usage of real_tty in ioctl() handling:
> > > > 
> > > > case TIOCGWINSZ:
> > > >                 return tiocgwinsz(real_tty, p);
> > > 
> > > Congratulations we've finally got there - and that is exactly the code in
> > > the current tty tree.
> > 
> > These patches are missing from 2.6.27. There you have:
> > 
> >     case TIOCGWINSZ:
> >         return tiocgwinsz(tty, p);
> 
> Yes I know. The rules for the stable tree are that it has to go upstream
> first. It has not gone upstream so it cannot go into the stable tree yet.
> As and when Linus takes the relevant changes I will send a set to the
> stable tree.

Nice to hear. I misunderstood the waiting for 2.6.27 part as in "Will be 
fixed there" ... until I saw your patchset.
-- 
You must be the arithmetic man -- you add trouble, subtract pleasure, divide
attention, and multiply ignorance. You have an inferiority complex -- and
it's fully justified. You used to be arrogant and obnoxious. Now you are
just the opposite. You are obnoxious and arrogant. -- Harry Murphy in a.2.hz
