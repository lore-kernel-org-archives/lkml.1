Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZHMOyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZHMOyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZHMOyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:54:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35174 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbZHMOyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:54:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: q-funk@iki.fi
Subject: Re: [Bug #13941] x86 Geode issue
Date: Thu, 13 Aug 2009 16:54:45 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <11fae7c70908130244k3f20954ewa23c5a57fbd60410@mail.gmail.com> <11fae7c70908130340w37782c04m861d2f429d639a9e@mail.gmail.com>
In-Reply-To: <11fae7c70908130340w37782c04m861d2f429d639a9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908131654.45227.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Martin-Éric Racine wrote:
> 2009/8/13 Martin-Éric Racine <q-funk@iki.fi>:
> > On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >> * Martin-Éric Racine <q-funk@iki.fi> wrote:
> >>> Yes, this bug is still valid.
> >>>
> >>> Ubuntu kernel team member Leann Ogasawara and I are slowly
> >>> bisecting our way through the changes that took place since 2.6.30
> >>> to find the commit that introduced this regression. Please stay
> >>> tuned.
> >>
> >> hm, the only outright Geode related commit was:
> >>
> >>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
> >>
> >> the jpg at:
> >>
> >>  http://launchpadlibrarian.net/28892781/00002.jpg
> >>
> >> is very out of focus - but what i could decypher suggests a
> >> pagefault crash in the VFS code, in generic_delete_inode().
> 
> This one might be a bit better:
> 
> http://launchpadlibrarian.net/30267494/2.6.31-5.24.jpg
> 
> >> Which could be a VFS bug, or a filesystem bug, or some unrelated
> >> memory corruption hitting the inode data structure.
> >
> > It could indeed be many things.
> >
> > I've been trying to boot this into a larger framebuffer to be able to
> > fit more data into my snapshots, but it appears that vga=795 doesn't
> > work anymore. Have we reverted to Hex values again or is this just an
> > issue of some kernel module missing from initrd?
> 
> Never mind. Seems that vesafb was blacklisted. Works now. See the
> image above. :)

OK, so I guess the bug should be closed?

Rafael
