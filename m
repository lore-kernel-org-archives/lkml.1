Return-Path: <linux-kernel-owner+w=401wt.eu-S939296AbXHIM3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939296AbXHIM3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765504AbXHIM3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:29:42 -0400
Received: from www.osadl.org ([213.239.205.134]:38524 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756385AbXHIM3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:29:41 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Thu, 9 Aug 2007 14:29:34 +0200
User-Agent: KMail/1.9.5
Cc: Valdis.Kletnieks@vt.edu, Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20070718232332.GA4620@kroah.com> <14166.1186611154@turing-police.cc.vt.edu> <20070809004058.6066fcd1@the-village.bc.nu>
In-Reply-To: <20070809004058.6066fcd1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091429.35075.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 09 August 2007 01:40 schrieb Alan Cox:
> > On the other hand, given that we've always said that closed-source stuff in
> > userspace is OK, the only way to not let *that* horse out of the barn is to
> > not merge UIO at all.
> 
> It really makes no difference whether it is merged or not. The test is
> "derivative work" and not 'linking'. 
> 
> A user space driver that is unusuable without a specific GPL kernel chunk
> is quite likely to be a derived work of the GPL kernel module 

I disagree. UIO is a documented kernel<->userspace interface, like sysfs
or proc. Using your argument, we would also have to say that a userspace
software that is unusable without sysfs is a derived work of the kernel.
But IANAL, tell me if I missed an important point.

> so the 
> documentation is giving poor advice however

I guess you mean this sentence:

"if you need to keep some parts of your driver closed source, you can do so 
without violating the GPL license on the kernel."

What would you write instead?

Thanks,
Hans
