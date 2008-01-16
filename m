Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYAPNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYAPNTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYAPNTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:19:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59213 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753050AbYAPNTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:19:08 -0500
Date: Wed, 16 Jan 2008 13:17:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: caglar@pardus.org.tr, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
Message-ID: <20080116131703.62d76abe@lxorguk.ukuu.org.uk>
In-Reply-To: <24149.1200455417@turing-police.cc.vt.edu>
References: <1200336080.318.8.camel@localhost.localdomain>
	<200801150237.44029.caglar@pardus.org.tr>
	<24149.1200455417@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Playing devil's advocate here - the claim is that EXPORT_SYMBOL_GPL is to
> indicate that code is getting too chummy with Linux internals.
> 
> However, in *this* case, isn't it "code that is too chummy with *GCC* internals",
> and thus it isn't our place to say what can and can't be done with code that
> is derivative of the GCC compiler? ;)

Yes. It would be something to discuss with the FSF.

However I don't think it matters. If you are doing instruction profiling
you need *all* the code built with profiling to get good results. You
can't rebuild the Nvidia modules so you can't profile them. 

Alan
