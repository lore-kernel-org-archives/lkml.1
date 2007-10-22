Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbXJVIJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbXJVIJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXJVIJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:09:43 -0400
Received: from ufisa.uninett.no ([158.38.152.126]:52634 "EHLO ufisa.uninett.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXJVIJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:09:41 -0400
Date: Mon, 22 Oct 2007 10:09:37 +0200 (CEST)
From: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>
X-X-Sender: kolla@halbrend.uninett.no
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] m68k: Use cc-cross-prefix (was: Re: [GI:wqT PULL] kbuild
 updates - second round)
In-Reply-To: <Pine.LNX.4.64.0710220915160.6155@anakin>
Message-ID: <alpine.LNX.0.9999.0710221007001.17646@halbrend.uninett.no>
References: <20071019204415.GA623@uranus.ravnborg.org> <Pine.LNX.4.64.0710211956280.6155@anakin> <20071021182245.GA5840@uranus.ravnborg.org> <Pine.LNX.4.64.0710212028560.6155@anakin> <alpine.LNX.0.9999.0710220303400.27496@firda.kolla.no>
 <Pine.LNX.4.64.0710220915160.6155@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Geert Uytterhoeven wrote:

> On Mon, 22 Oct 2007, Kolbjørn Barmen wrote:
> > On Sun, 21 Oct 2007, Geert Uytterhoeven wrote:
> > > +ifneq ($(SUB_ARCH),$(ARCH))
> > > +     ifeq ($(CROSS_COMPILE),)
> > > +            CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu- m68k-linux-)
> > 
> > I've not paid much attention to discussion over this (I tend to build
> > natively, less stress :) ), so pardon my ignorance. Does the above make
> > any difference for me when I use CROSS_COMPILE=m68k-unknown-linux-gnu-,
> > or does it just detect m68k-linux-gnu- and m68k-linux-?
> 
> No, it makes no difference if you explicitly pass
> CROSS_COMPILE=m68k-unknown-linux-gnu-.
> 
> If you want, we can add m68k-unknown-linux-gnu- to the list in
> arch/m68k/Makefile, so it cab be autodetected.

Sure, that would be excellent - thanks :)

-- kolla
