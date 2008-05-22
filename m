Return-Path: <linux-kernel-owner+w=401wt.eu-S935376AbYEVJs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376AbYEVJs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYEVJsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:48:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53833 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751625AbYEVJsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:48:17 -0400
Date: Thu, 22 May 2008 10:34:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, Christoph Hellwig <hch@infradead.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3, RFC] watchdog dev BKL pushdown
Message-ID: <20080522103445.3c6b69e9@core>
In-Reply-To: <200805202300.35591.arnd@arndb.de>
References: <13762.1211142411@vena.lwn.net>
	<20080520154711.GD2724@infomag.infomag.iguana.be>
	<20080520193135.432acc90@core>
	<200805202300.35591.arnd@arndb.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you planning this as a transitional method for
> converting drivers, or are you aware of any driver that
> actually needs its own ioctl method?

I added it "in case" and to allow for special cases later. We may not
need it for any existing devices.

> All the ioctl numbers are compatible, so it would be good
> to register the watchdog ioctl function as compat_ioctl
> as well. Once all drivers are using the common abstraction,
> we can also kill their COMPATIBLE_IOCTL() entries in
> fs/compat_ioctl.c.

Good point. Wim will no doubt comment on all this once he has finished
his more pressing jobs.

Alan
