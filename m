Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbXJVHQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbXJVHQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXJVHQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:16:39 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:44581 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXJVHQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:16:36 -0400
X-Greylist: delayed 47935 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 03:16:35 EDT
Date: Mon, 22 Oct 2007 09:16:27 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] m68k: Use cc-cross-prefix (was: Re: [GI:wqT PULL] kbuild
 updates - second round)
In-Reply-To: <alpine.LNX.0.9999.0710220303400.27496@firda.kolla.no>
Message-ID: <Pine.LNX.4.64.0710220915160.6155@anakin>
References: <20071019204415.GA623@uranus.ravnborg.org>
 <Pine.LNX.4.64.0710211956280.6155@anakin> <20071021182245.GA5840@uranus.ravnborg.org>
 <Pine.LNX.4.64.0710212028560.6155@anakin> <alpine.LNX.0.9999.0710220303400.27496@firda.kolla.no>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-1399845207-1193037340=:6155"
Content-ID: <Pine.LNX.4.64.0710220915450.6155@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-1399845207-1193037340=:6155
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0710220915451.6155@anakin>

On Mon, 22 Oct 2007, Kolbjørn Barmen wrote:
> On Sun, 21 Oct 2007, Geert Uytterhoeven wrote:
> > +ifneq ($(SUB_ARCH),$(ARCH))
> > +     ifeq ($(CROSS_COMPILE),)
> > +            CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu- m68k-linux-)
> 
> I've not paid much attention to discussion over this (I tend to build
> natively, less stress :) ), so pardon my ignorance. Does the above make
> any difference for me when I use CROSS_COMPILE=m68k-unknown-linux-gnu-,
> or does it just detect m68k-linux-gnu- and m68k-linux-?

No, it makes no difference if you explicitly pass
CROSS_COMPILE=m68k-unknown-linux-gnu-.

If you want, we can add m68k-unknown-linux-gnu- to the list in
arch/m68k/Makefile, so it cab be autodetected.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-1399845207-1193037340=:6155--
