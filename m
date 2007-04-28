Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXD1U3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXD1U3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXD1U3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:29:34 -0400
Received: from www.osadl.org ([213.239.205.134]:48232 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751922AbXD1U3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:29:32 -0400
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Bill Davidsen <davidsen@tmr.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org,
       Benedikt Spranger <b.spranger@linutronix.de>
In-Reply-To: <20070428211515.4e9fd8c5@the-village.bc.nu>
References: <20070427224957.GA17967@kroah.com> <4633A6D7.3030806@tmr.com>
	 <200704282203.31141.hjk@linutronix.de>
	 <20070428211515.4e9fd8c5@the-village.bc.nu>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 22:31:37 +0200
Message-Id: <1177792297.7646.297.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 21:15 +0100, Alan Cox wrote:
> > > I have a political question, if I have a user space driver, is my kernel 
> > > tainted or not? 
> > 
> > Surely not. By using the kernel's userspace interface, you create no
> > "derived work" of the kernel. See COPYING in the root directory of the 
> > kernel sources for details.
> 
> That only covers normal system calls - but I don't think thats what is
> relevant, taints are for debug assistance not politics.
> 
> I think we should have a taint flag for UIO type drivers. Not for any
> licensing or political reason but for the simple fact it means that there
> may be other complexities to debugging - and not the same one as a binary
> module. Probably we want the same marker for mmap /dev/mem too.

I agree, if we make it entirely clear that the flag is nonpolitical. 

	tglx


