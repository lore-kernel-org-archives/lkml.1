Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXEXKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXEXKxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbXEXKxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:53:03 -0400
Received: from [81.2.110.250] ([81.2.110.250]:36403 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755855AbXEXKxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:53:01 -0400
Date: Thu, 24 May 2007 11:55:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1: IDE compile error
Message-ID: <20070524115549.01c0e1ca@the-village.bc.nu>
In-Reply-To: <200705240145.38055.bzolnier@gmail.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	<20070516185552.GA4086@stusta.de>
	<200705240145.38055.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > hd.c:(.init.text+0x44a7d): undefined reference to `drive_info'
> > hd.c:(.init.text+0x44a89): undefined reference to `drive_info'
> > hd.c:(.init.text+0x44a95): undefined reference to `drive_info'
> > hd.c:(.init.text+0x44aa1): undefined reference to `drive_info'
> > hd.c:(.init.text+0x44aad): undefined reference to `drive_info'
> > drivers/built-in.o:hd.c:(.init.text+0x44ab9): more undefined references to `drive_info' follow
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> > <--  snip  -->
> > 
> > Considering the fact that we have two more recent drivers with the same 
> > functionality, it might be an option to simply remove this driver...
> 
> Care to send a patch?

hd.c can drive MFM and RLL disks and drivers/ide cannot. Although it
really wants burying further down the config tree the ability to read MFM
and RLL disks when recovering ancient data is useful and people do
actually use this driver now and then rescuing stuff like twenty year old
datasets.

It thus needs fixing not removing.


Alan
