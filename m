Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYDYH3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYDYH3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYDYH3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:29:17 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:56211 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbYDYH3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:29:16 -0400
Date: Fri, 25 Apr 2008 09:29:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joel Becker <Joel.Becker@oracle.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 14/15] m68k: Update defconfigs
In-Reply-To: <20080424211124.GD2131@mail.oracle.com>
Message-ID: <Pine.LNX.4.64.0804250922360.21224@anakin>
References: <20080424182940.424312704@mail.of.borg> <20080424183243.884021921@mail.of.borg>
 <20080424211124.GD2131@mail.oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Joel Becker wrote:
> On Thu, Apr 24, 2008 at 08:29:54PM +0200, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > Update the m68k defconfigs
> 
> <snip>
> 
> >  CONFIG_OCFS2_FS=m
> > +# CONFIG_OCFS2_FS_O2CB is not set
> > +# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
> >  # CONFIG_OCFS2_DEBUG_MASKLOG is not set
> >  # CONFIG_OCFS2_DEBUG_FS is not set
> 
> 	In these defconfigs, you disable the cluster stack drivers for
> ocfs2.  This means that ocfs2 can only work as a local filesystem.
> While it will work fine that way, I figured I'd send an email in case
> that wasn't your intention :-)  I note that the following
> multi_defconfig has the cluster stack drivers enabled:
> 
> +CONFIG_OCFS2_FS=m
> +CONFIG_OCFS2_FS_O2CB=m
> +CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m

multi_defconfig is supposed to be the `or' of all the others (minus Sun 3),
so I have to make some changes :-)

I'll enable the cluster stack drivers in all configs, if it doesn't make
much sense not to have them.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
