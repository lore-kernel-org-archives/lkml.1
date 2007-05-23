Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbXEWV3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbXEWV3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbXEWV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:29:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54255 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756042AbXEWV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:29:06 -0400
Date: Wed, 23 May 2007 22:30:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       rmk@arm.linux.kernel.org, spyro@f2s.com, starvik@axis.com,
       ysato@users.sourceforge.jp, "Luck, Tony" <tony.luck@intel.com>,
       takata@linux-m32r.org, chris@zankel.net, uclinux-v850@lsi.nec.co.jp,
       kyle@parisc-linux.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] m68k: Enable arbitary speed tty support
Message-ID: <20070523223008.32f65e0a@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0705232233360.10610@anakin>
References: <20070523174446.37abfa7a@the-village.bc.nu>
	<Pine.LNX.4.64.0705232117260.10610@anakin>
	<20070523205645.07b03581@the-village.bc.nu>
	<Pine.LNX.4.64.0705232233360.10610@anakin>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not `#define termios2 ktermios' (or vice versa) on platforms where
> they are the same?

Because #define is a bit of a loose cannon when it comes to substitutions
and I didn't want nasty suprises. Also because ktermios may change in
future and I don't want to have to liase with 4 million port maintainers
when it does. The whole point of ktermios was to isolate the kernel and
user space views.

Alan
