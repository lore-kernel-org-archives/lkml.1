Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbXJ1Wv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbXJ1Wv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXJ1Wvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:51:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54735 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbXJ1Wvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:51:52 -0400
Date: Sun, 28 Oct 2007 22:53:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc1-git4: Reported regressions from 2.6.23
Message-ID: <20071028225351.012e7569@the-village.bc.nu>
In-Reply-To: <200710282351.56284.rjw@sisk.pl>
References: <200710282351.56284.rjw@sisk.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject		: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi M5229 secondary channel
> Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> References	: http://marc.info/?l=linux-kernel&m=119342005216716&w=2
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9252
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>

2.6.23 did not have pata_acpi. Its also not clear this is a bug in
pata_acpi as opposed to pata_ali which knows about the ALi quirks. The
ACPI and ATA specs sort of disagree here so I'll be trying to fix it
anyway.

