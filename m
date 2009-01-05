Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZAELpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZAELpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZAELoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:44:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34201 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755270AbZAELoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:44:05 -0500
Date: Mon, 5 Jan 2009 11:43:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105114329.7973057b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090104183834.GB17558@mit.edu>
References: <20090103123813.GA1512@ucw.cz>
	<4960BB2D.3060000@gmail.com>
	<20090104183834.GB17558@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If dm supported barriers, this wouldn't be an issue.  Personally, I

"If the dm people applied the patches to support barriers" I believe is
the correct description - Andi ? 

dm and md want fixing and even in the md case it isn't hard to do right.

> > or disabling write cache (but, as Alan Cox said, this  
> > shortens the lifespan of the disk).
> 
> Huh?  I've never heard an assertion that disabling the write cache (I
> assume you mean using write-through caching as opposed to write-back
> caching), shortens the lifespan of disk drives.  Aggressive battery

Thats what I was told by a disk vendor - simply because the drive makes a
lot more mechanical movements and writes.

> your noticing it, you can avoid running fsck at boot time.  It's
> really more about shorting the boot time after a crash more than
> anything else.

That depends enormously on your environment. In a secure environment full
data journalling is practically essential to avoid the tiny risk of bits
of important data turning up in another users file.

Alan
