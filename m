Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbXGBOYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbXGBOYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbXGBOYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:24:32 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58197 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbXGBOYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:24:31 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 10:22:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: why does git perpetually complain about include/asm-blackfin/macros.h?
In-Reply-To: <4689073D.1020802@garzik.org>
Message-ID: <Pine.LNX.4.64.0707021021090.20805@localhost.localdomain>
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain> 
 <4688EF9B.8020405@garzik.org> <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
 <4689073D.1020802@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Jeff Garzik wrote:

> Jesper Juhl wrote:
> > On 02/07/07, Jeff Garzik <jeff@garzik.org> wrote:
> > > Robert P. J. Day wrote:
> > > >   for the umpteenth time, after doing a pull, i see this:
> > > >
> > > > $ git diff
> > > > diff --git a/include/asm-blackfin/macros.h
> > > b/include/asm-blackfin/macros.h
> > > > deleted file mode 100644
> > > > index e69de29..0000000
> > > > $
> > >
> > > I have the same problem.  git 1.5.0.6 on Fedora Core 5 or 6.
> > >
> > > I even tried a completely fresh clone, but the problem still appears.
> > >
> > I've seen that as well, but in my case doing a
> > $ git reset --hard master
> > fixed it.
>
> Sure.  git checkout -f fixes it too.
>
> But then it reappears the every time I switch branches.

same here -- checkout fixes it, but back it comes after the next pull.
not fatal -- just annoying.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
