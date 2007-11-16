Return-Path: <linux-kernel-owner+w=401wt.eu-S934431AbXKPAvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbXKPAvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbXKPAvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:51:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43269 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757343AbXKPAvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:51:03 -0500
Date: Fri, 16 Nov 2007 00:48:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Bron Gondwana <brong@fastmail.fm>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm, riel <riel@redhat.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
 Bugs)
Message-ID: <20071116004851.1ec5c93d@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net>
	<20071113110259.44c56d42.akpm@linux-foundation.org>
	<alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>
	<20071113130411.26ccae12.akpm@linux-foundation.org>
	<alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
	<20071115040708.GB15302@brong.net>
	<alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
	<20071115052538.GA21522@brong.net>
	<alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
	<20071115115049.GA8297@brong.net>
	<alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
	<1195155601.22457.25.camel@lappy>
	<1195159457.22457.35.camel@lappy>
	<alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
	<1195162015.22457.52.camel@lappy>
	<alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So the _only_ explanation today for 12GB on a 32-bit machine is
>  (a) insanity
> or 
>  (b) being so lazy as to not bother to upgrade
> and in either case, my personal reaction is "I'm *not* crazy, and yes, I'm 
> lazy too, and I can't give a rats *ss about those problems".

12GB-16GB worked well historically so its a regression. Above 16GB its
all utterly mad.

You forgot reason (c) though

(c) 32bit is a tested approved certified etc environment - essentially
conservativsm and paranoia, and its hard to explain to some of these
people that the right answer really is less RAM or 64bit, especially as
they may already know it but have a 12 month process to prove and certify
a system configuration.

> HIGHMEM was a mistake in the first place. It's one that we can live with, 
> but I refuse to support it more than it needs to be supported. And 12GB is 
> *way* past the end of what is worth supporting.

Highmem to 4GB was sensible. Highmem to 8GB was pushing it.

Alan
