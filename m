Return-Path: <linux-kernel-owner+w=401wt.eu-S965828AbXHIPYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828AbXHIPYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934455AbXHIPYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:24:01 -0400
Received: from www.osadl.org ([213.239.205.134]:38019 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765585AbXHIPX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:23:59 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Thu, 9 Aug 2007 17:23:56 +0200
User-Agent: KMail/1.9.5
Cc: Valdis.Kletnieks@vt.edu, Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20070718232332.GA4620@kroah.com> <200708091502.45417.hjk@linutronix.de> <20070809151220.3f389efc@the-village.bc.nu>
In-Reply-To: <20070809151220.3f389efc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091723.57041.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 09 August 2007 16:12 schrieb Alan Cox:
> > That's no UIO invention. Userspace software that uses kernel interfaces like
> > syscall, device files, sysfs, and so on, is by definition _not_ a derived work
> > of the kernel and can be distributed under any license.
> 
> This I believe incorrect. Please cite caselaw if you know better.

What about the statement at the top of COPYING in the top level kernel source 
directory?

I know, you've got examples in mind where a kernel module and a userspace
program are dependent on each other and none of them can be used without the 
other. Of course, we've got such a case for a UIO kernel module and userspace
driver. But if the degree of dependency between kernel and userspace can
constitute a different legal situation, then we have a _very_ large legal
grayzone.

> 
> > With UIO, you have a kernel module that is so small, that even somebody who
> > hasn't got the hardware can easily review it and tell if the code is OK or not.
> > It is easy to maintain and doesn't reveal any secrets about the hardware.
> 
> False
> 
> Because you have no idea if the interface is correct or the userspace is
> doing stuff like triggering DMA to arbitary addresses via the interface
> or mmap functions. If it does so then even if its root only you've blown
> your security model.

OK, I agree. But in comparison to using /dev/mem for these tasks, I still 
consider UIO an improvement. 

Thanks,
Hans
