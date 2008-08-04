Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYHDQBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYHDQBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYHDQA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:00:56 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:36311 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYHDQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:00:56 -0400
Date: Mon, 4 Aug 2008 18:00:53 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Greg Ungerer <gerg@snapgear.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
In-Reply-To: <200808041635.11854.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0808041750110.16461@anakin>
References: <20080728200500.GA14284@uranus.ravnborg.org> <4892A719.5090302@snapgear.com>
 <Pine.LNX.4.64.0808032205120.23329@anakin> <200808041635.11854.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-1983824005-1217865653=:16461"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-1983824005-1217865653=:16461
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 4 Aug 2008, Arnd Bergmann wrote:
> On Sunday 03 August 2008, Geert Uytterhoeven wrote:
> > There seem to be 3 classes of m68knommu header files:
> >   1. Plain files (some of them may be (nearly) identical copies of the
> >      m68k variants,
> 
> For reference, I found the files auxvec.h, device.h, emergency-restart.h,
> futex.h, ioctl.h, irq_regs.h, kdebug.h, mutex.h and topology.h to be
> entirely identical, so you may remove the m68knommu variants with your
> approach.

Thanks for the list!

> >   2. Files that just include the m68k variant,
> >   3. Files that include the m68k variant and do something more (pci.h and
> >      setup.h).
> >
> > Since I don't think we want to do the m68k/m68knommu merge right now
> > (Sorry Arnd, I'll keep your script in mind anyway!), the simplest way is to:
> >  - Remove all files from class 2, and add to the Makefile:
> 
> Does this work with the exported headers? I guess it should if you
> always use the m68k exports for m68knommu as well, but if that's
> possible is is a question you haven't answered yet.

Oops, forgot about the exported headers... Don't know. Sam?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-1983824005-1217865653=:16461--
