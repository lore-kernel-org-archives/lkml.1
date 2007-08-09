Return-Path: <linux-kernel-owner+w=401wt.eu-S940214AbXHIOFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940214AbXHIOFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940081AbXHIOFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:05:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53111 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S940052AbXHIOFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:05:15 -0400
Date: Thu, 9 Aug 2007 15:12:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: Valdis.Kletnieks@vt.edu, Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-ID: <20070809151220.3f389efc@the-village.bc.nu>
In-Reply-To: <200708091502.45417.hjk@linutronix.de>
References: <20070718232332.GA4620@kroah.com>
	<9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
	<14166.1186611154@turing-police.cc.vt.edu>
	<200708091502.45417.hjk@linutronix.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That's no UIO invention. Userspace software that uses kernel interfaces like
> syscall, device files, sysfs, and so on, is by definition _not_ a derived work
> of the kernel and can be distributed under any license.

This I believe incorrect. Please cite caselaw if you know better.

> With UIO, you have a kernel module that is so small, that even somebody who
> hasn't got the hardware can easily review it and tell if the code is OK or not.
> It is easy to maintain and doesn't reveal any secrets about the hardware.

False

Because you have no idea if the interface is correct or the userspace is
doing stuff like triggering DMA to arbitary addresses via the interface
or mmap functions. If it does so then even if its root only you've blown
your security model.

