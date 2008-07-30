Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbYG3M0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbYG3M0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYG3M0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:26:09 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:56242 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbYG3M0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:26:08 -0400
Date: Wed, 30 Jul 2008 14:26:04 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>, Greg Ungerer <gerg@snapgear.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
In-Reply-To: <3995.1217410495@redhat.com>
Message-ID: <Pine.LNX.4.64.0807301422380.3316@anakin>
References: <200807300907.25186.arnd@arndb.de> <20080728200500.GA14284@uranus.ravnborg.org>
 <48900EE4.8030606@snapgear.com> <3995.1217410495@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, David Howells wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I think the more interesting aspect in m68knommu is what happens
> > when asm-m68k gets moved. Does that work as well?
> 
> Can m68knommu be merged into m68k and be made contingent on CONFIG_MMU?  This
> is what FRV does.

Sure it can ;-)

Actually I did a bit of work to add nommu support to m68k to make it
boot on old MMU-less Amigas, but it dates back to the 2.6.8.1 era...

The bigger issue is in those parts that are done differently by m68k and
m68knommu (esp. head.S).

Who's gonna take the work? :-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
