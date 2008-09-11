Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYIKKDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYIKKDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYIKKDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:03:44 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:48161 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYIKKDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:03:44 -0400
Date: Thu, 11 Sep 2008 12:03:36 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/MIPS Development <linux-mips@linux-mips.org>
Subject: Re: [PATCH 0/3] Globally defining phys_addr_t
In-Reply-To: <48C8D76B.10901@goop.org>
Message-ID: <Pine.LNX.4.64.0809111202560.1545@anakin>
References: <48C8D76B.10901@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008, Jeremy Fitzhardinge wrote:
> This is a repost of a little 3-patch series which Andrew has been
> carrying in -mm.  It cleans up the definition of phys_addr_t to make it
> kernel-wide rather than x86-specific, and fixes up PFN_PHYS() to use it
> to avoid address truncation.
> 
> We currently have a few workarounds for this problem in the tree, but
> Alex found another bug caused by PFN_PHYS(), so it's probably better if
> you bring these patches into tip.git for now.
> 
> PowerPC also defines a phys_addr_t with the same meaning as x86; the
> powerpc arch maintainers are happy with these patches.

If I'm not mistaking, this is also true for some MIPS machines.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
