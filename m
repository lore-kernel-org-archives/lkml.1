Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYGWSzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYGWSzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYGWSzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:55:05 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:49126 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYGWSzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:55:04 -0400
Date: Wed, 23 Jul 2008 20:55:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: ttydev tree build failure
In-Reply-To: <20080723172837.3d784d85@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0807232048440.24017@anakin>
References: <20080723171743.1436cf2a.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0807231436310.1185@anakin> <20080723154610.348ffc07@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0807231748250.20868@anakin> <20080723164731.00c163f1@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0807231838470.21737@anakin> <20080723172837.3d784d85@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008, Alan Cox wrote:
> > Update all drivers when making core tty infrastructure changes?
> > Thanks!
> 
> I don't have an Amiga with that board, I don't have an obscure VME 68K
> board. The changes required at this point would be tricky to verify
> without hardware, and the upcoming changes will require significant
> changes to all the hardware drivers, which will need someone to actually
> maintain the drivers, or to drop them.

IC, testing/maintaining non-trival changes is a different situation.

But it would still be nice to announce such removals/breakings in advance,
cfr. Documentation/feature-removal-schedule.txt. At least we knew the old
NCR53C9x core was going away, taken with it all drivers depending on it...

Anyone who cares about these drivers (ser_a2232 and vme_scc, perhaps
others?)?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
