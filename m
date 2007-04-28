Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbXD1UMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbXD1UMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031201AbXD1UMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:12:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58304 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756106AbXD1UMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:12:01 -0400
Date: Sat, 28 Apr 2007 21:15:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070428211515.4e9fd8c5@the-village.bc.nu>
In-Reply-To: <200704282203.31141.hjk@linutronix.de>
References: <20070427224957.GA17967@kroah.com>
	<4633A6D7.3030806@tmr.com>
	<200704282203.31141.hjk@linutronix.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have a political question, if I have a user space driver, is my kernel 
> > tainted or not? 
> 
> Surely not. By using the kernel's userspace interface, you create no
> "derived work" of the kernel. See COPYING in the root directory of the 
> kernel sources for details.

That only covers normal system calls - but I don't think thats what is
relevant, taints are for debug assistance not politics.

I think we should have a taint flag for UIO type drivers. Not for any
licensing or political reason but for the simple fact it means that there
may be other complexities to debugging - and not the same one as a binary
module. Probably we want the same marker for mmap /dev/mem too.

Alan
