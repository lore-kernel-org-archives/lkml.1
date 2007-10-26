Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbXJZSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbXJZSH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXJZSHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:07:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40646 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754052AbXJZSHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:07:12 -0400
Date: Fri, 26 Oct 2007 19:08:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Haley" <aph@redhat.com>
Subject: Re: Is gcc thread-unsafe?
Message-ID: <20071026190856.18510fc4@the-village.bc.nu>
In-Reply-To: <e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
	<e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
	<alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
	<alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
	<e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> non-volatile variables. But for asm statements this can be solved by
> adding memory to the list of clobbered registers -- this will prevent
> any reordering of manipulations of non-volatile variables and asm
> statements.

IFF the processor doesn't reorder them in hardware, which on some
processors is visibly out of order when viewed from an I/O device or
another CPU.

You can stop the compiler but not the CPU - and some processors will
certainly speculatively load across conditionals, reorder writes etc

