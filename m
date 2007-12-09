Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXLINsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXLINsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXLINry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:47:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45161 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbXLINrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:47:53 -0500
Date: Sun, 9 Dec 2007 13:42:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209134217.7ff02dd2@the-village.bc.nu>
In-Reply-To: <475B9270.6070902@gmail.com>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208015227.3a1c7fae.akpm@linux-foundation.org>
	<475B9270.6070902@gmail.com>
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

> If we fail to find out the solution in time, we always have the
> alternative of backing out the ATAPI transfer chunk size update.  This

Which will break far more controllers and drives than it fixes, so
backing it out is nonsensical and not in the general good.

> will break some other cases which were fixed by the change but those
> won't be regressions at least and we can add transfer chunk size
> update with other changes to 2.6.25.

Great, make everyone else wait another three months for a working CD
drive. The one off regression appears far less harmful than a revert.

Tejun - instead of backing out important updates for 2.6.24 we should
just blacklist that specific drive for now and sort it nicely in 2.6.25,
not revert stuff and break everyone elses ATAPI devices.

Alan
