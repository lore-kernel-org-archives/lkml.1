Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbXHXXKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbXHXXKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbXHXXJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:09:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41091 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755592AbXHXXJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:09:56 -0400
Date: Sat, 25 Aug 2007 00:18:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dermot Bradley" <dermot.bradley@sla-mobile.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Message-ID: <20070825001808.38491822@the-village.bc.nu>
In-Reply-To: <94439DDF32D7464A916B5068EFF76B3B0225E6D5@bart.tisolutions.biz>
References: <94439DDF32D7464A916B5068EFF76B3B0225E6D5@bart.tisolutions.biz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (1) there is 1 newer official BIOS release and 2 beta BIOSes out for
> this motherboard. The recent official BIOS (0901) does mention Linux:
> 
>    "Fixed Red Hat Enterprise Linux 4 installation failed"
> 
> So maybe a BIOS update will fix things.

Yep

> So I guess these drives should be added to the ata_blacklist_entry in
> libata-core.c with ATA_HORKAGE_NONCQ?

If you keep seeing the problem then yes
