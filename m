Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbZLRMNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbZLRMNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZLRMNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:13:41 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:54764 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZLRMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:13:40 -0500
Date: Fri, 18 Dec 2009 13:13:38 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Evgeniy Polyakov <zbr@ioremap.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: pohmelfs needs I_LOCK
Message-ID: <alpine.DEB.2.00.0912181311300.13567@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a conflict in 2.6.33-rc1 between the following 2 commits:

commit ff8079d4f1016a12e34ab323737314f24127dd ("kill I_LOCK")
commit e3eec94dc91c39f2bd7939294b9cd4a65a82db44 ("Staging: pohmelfs: directory
operations")

drivers/staging/pohmelfs/dir.c: In function 'pohmelfs_remove_entry':
drivers/staging/pohmelfs/dir.c:725: error: 'I_LOCK' undeclared (first use in this function)
drivers/staging/pohmelfs/dir.c:725: error: (Each undeclared identifier is reported only once
drivers/staging/pohmelfs/dir.c:725: error: for each function it appears in.)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
