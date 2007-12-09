Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbXLIPbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbXLIPbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 10:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXLIPa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 10:30:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59312 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbXLIPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 10:30:56 -0500
Date: Sun, 9 Dec 2007 15:25:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209152509.5c6e33a2@the-village.bc.nu>
In-Reply-To: <475C0522.7080702@gmail.com>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208015227.3a1c7fae.akpm@linux-foundation.org>
	<475B9270.6070902@gmail.com>
	<20071209134217.7ff02dd2@the-village.bc.nu>
	<475C0522.7080702@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Newly broken ones will be regressions.  How many do we fix by the
> change?  On SATA, setting the correct transfer chunk size doesn't seem
> to fix many.

Regressions are not some kind of grand evil. Better to regress the odd
device than continue to break entire controllers.

> > Tejun - instead of backing out important updates for 2.6.24 we should
> > just blacklist that specific drive for now and sort it nicely in 2.6.25,
> > not revert stuff and break everyone elses ATAPI devices.
> 
> We'll need to blacklist setting transfer chunk size, eek, and let's
> leave that as the last resort and hope that we find the solution soon.
> Blacklist takes time to develop and temporary blacklist for just one
> release doesn't sound like a good idea.

It seems to be sensible to me *if* it is just this one device we are
somehow confusing and that one device is holding up fixing everything
else.
