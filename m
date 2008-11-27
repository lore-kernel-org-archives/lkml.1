Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYK0AmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYK0AmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYK0AmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:42:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:53421 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752302AbYK0AmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:42:14 -0500
Date: Thu, 27 Nov 2008 01:42:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, linux-doc@vger.kernel.org
Subject: Re: Document hadling of bad memory
In-Reply-To: <20081126161521.GC1983@elf.ucw.cz>
Message-ID: <alpine.LNX.1.10.0811270141370.19853@jikos.suse.cz>
References: <20081126161521.GC1983@elf.ucw.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ linux-doc@vger.kernel.org added, these should be the proper guys to 
  merge this ]

On Wed, 26 Nov 2008, Pavel Machek wrote:

> 
> Document how to deal with bad memory reported with memtest.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/Documentation/bad_memory.txt b/Documentation/bad_memory.txt
> new file mode 100644
> index 0000000..df84162
> --- /dev/null
> +++ b/Documentation/bad_memory.txt
> @@ -0,0 +1,45 @@
> +March 2008
> +Jan-Simon Moeller, dl9pf@gmx.de
> +
> +
> +How to deal with bad memory e.g. reported by memtest86+ ?
> +#########################################################
> +
> +There are three possibilities I know of:
> +
> +1) Reinsert/swap the memory modules
> +
> +2) Buy new modules (best!) or try to exchange the memory
> +   if you have spare-parts
> +
> +3) Use BadRAM or memmap
> +
> +This Howto is about number 3) .
> +
> +
> +BadRAM
> +######
> +BadRAM is the actively developed and available as kernel-patch
> +here:  http://rick.vanrein.org/linux/badram/
> +
> +For more details see the BadRAM documentation.
> +
> +memmap
> +######
> +
> +memmap is already in the kernel and usable as kernel-parameter at
> +boot-time.  Its syntax is slightly strange and you may need to
> +calculate the values by yourself!
> +
> +Syntax to exclude a memory area (see kernel-parameters.txt for details):
> +memmap=<size>$<address>
> +
> +Example: memtest86+ reported here errors at address 0x18691458, 0x18698424 and
> +         some others. All had 0x1869xxxx in common, so I chose a pattern of
> +         0x18690000,0xffff0000.
> +
> +With the numbers of the example above:
> +memmap=64K$0x18690000
> + or
> +memmap=0x10000$0x18690000
> +
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

-- 
Jiri Kosina
SUSE Labs
