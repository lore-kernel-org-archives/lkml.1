Return-Path: <linux-kernel-owner+w=401wt.eu-S939974AbXHIOD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939974AbXHIOD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935256AbXHIOC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:02:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53105 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S939789AbXHIOCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:02:54 -0400
Date: Thu, 9 Aug 2007 15:09:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: Valdis.Kletnieks@vt.edu, Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-ID: <20070809150942.2663498d@the-village.bc.nu>
In-Reply-To: <200708091429.35075.hjk@linutronix.de>
References: <20070718232332.GA4620@kroah.com>
	<14166.1186611154@turing-police.cc.vt.edu>
	<20070809004058.6066fcd1@the-village.bc.nu>
	<200708091429.35075.hjk@linutronix.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> I disagree. UIO is a documented kernel<->userspace interface, like sysfs
> or proc. Using your argument, we would also have to say that a userspace
> software that is unusable without sysfs is a derived work of the kernel.
> But IANAL, tell me if I missed an important point.

It depends how closely the bits are tied. As far as I can ascertain there
is no simple yes/no answer and whether you can do so depends a great deal
upon how tightly bound the two are (consider the difference between the
intel ipw daemon which is integrated very tightly into the old ipw3945
driver and  a script monitoring CPU temperature via a sysfs file)

> > so the 
> > documentation is giving poor advice however
> 
> I guess you mean this sentence:
> 
> "if you need to keep some parts of your driver closed source, you can do so 
> without violating the GPL license on the kernel."
> 
> What would you write instead?

I would simply remove the statement. Leave it to the lawyers.

Alan
