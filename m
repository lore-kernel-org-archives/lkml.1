Return-Path: <linux-kernel-owner+w=401wt.eu-S1030690AbXDPOpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030690AbXDPOpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030669AbXDPOpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:45:43 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54966 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030690AbXDPOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:45:43 -0400
X-Originating-Ip: 24.6.145.253
Date: Mon, 16 Apr 2007 10:44:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: so what *is* obsolete and removable?
In-Reply-To: <9a8748490704151450i251b8b1av8439bc275e982866@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704161030040.6837@localhost.localdomain>
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
 <9a8748490704151450i251b8b1av8439bc275e982866@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-14.854, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007, Jesper Juhl wrote:

> On 15/04/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >
> >   in a recent posting, ian anderson suggested that, before kernel
> > features are removed, they should spend a reasonable amount of
> > time in the feature removal file to give everyone fair warning.
> > if that's the case, then there are a *bunch* of things that should
> > perhaps be added to that file real soon now just to start the
> > clock ticking.
> >
> [snip]
> > ./sound/oss/Kconfig:    bool "Obsolete OSS drivers"
> > ./sound/oss/Kconfig:      This option enables support for obsolete OSS
> > drivers that
> >
> >   clearly, that was a fairly brainless search, but it still
> > reveals a pile of stuff that's "obsolete" (whatever that means in
> > the context in which it's used).  so what's really obsolete?
> >
> IIRC Adrian Bunk is handling the removal of obsolete OSS drivers and
> doing a nice job at it. Dunno about the rest of the stuff.

oh, i realize that a number of those examples from my earlier post
were already handled/being handled (i don't even look under OSS these
days when doing any cleanup).

my point was that, if ian's position is valid and stuff shouldn't be
removed without fair warning, then a lot of that stuff should get
entered into the feature removal file real soon now.

rday

p.s.  again, if you run the simple grep i mentioned before:

  $ grep -iw obsolete $(find . -name Kconfig\*)

you find some odd combinations, such as this from net/ipv4/Kconfig:

config ARPD
        bool "IP: ARP daemon support (EXPERIMENTAL)"
        depends on EXPERIMENTAL
        ---help---
        ...
        This code is experimental and also obsolete...

the thought of something being both experimental *and* obsolete is a
bit weird, is it not?

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
