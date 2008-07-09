Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYGIT5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYGIT5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYGIT5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:57:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55282 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227AbYGIT5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:57:22 -0400
Date: Wed, 9 Jul 2008 20:21:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2] serial: 8250: fix shared interrupts issues with SMP
 and RT kernels
Message-ID: <20080709202131.362943ea@the-village.bc.nu>
In-Reply-To: <20080709192943.GA12278@polina.dev.rtsoft.ru>
References: <20080623232957.GA5111@polina.dev.rtsoft.ru>
	<20080624001221.GA20685@elte.hu>
	<20080701134343.GA1865@polina.dev.rtsoft.ru>
	<20080701144353.7285805d@lxorguk.ukuu.org.uk>
	<20080701150254.GA13390@polina.dev.rtsoft.ru>
	<20080709192943.GA12278@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But this can't happen here. IRQ will not grab the up->port.lock,
> > because port isn't registered in the 8250 IRQ handling chain (yet).
> 
> Alan, are there any issues with the proof or the patch itself?

The logic looks fine, the analysis looks fine. 

Alan
