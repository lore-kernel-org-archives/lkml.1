Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYGaXdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYGaXdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYGaXdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:33:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34986 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbYGaXdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:33:37 -0400
Date: Fri, 1 Aug 2008 00:15:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: change remove NR_IRQS in 8250.c
Message-ID: <20080801001508.676a5782@lxorguk.ukuu.org.uk>
In-Reply-To: <m163ql3ox2.fsf@frodo.ebiederm.org>
References: <200807291414.55479.yhlu.kernel@gmail.com>
	<200807302109.21519.yhlu.kernel@gmail.com>
	<200807302110.10585.yhlu.kernel@gmail.com>
	<200807310126.12572.yhlu.kernel@gmail.com>
	<m1iqum2rya.fsf@frodo.ebiederm.org>
	<20080731145752.2aec5727@lxorguk.ukuu.org.uk>
	<m163ql3ox2.fsf@frodo.ebiederm.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The practical question is how do we cleanly kill the array
> irq_lists[NR_IRQS].  YH's hack where he isn't paying attention to what
> the code is doing and just trying to avoid the problem is not
> something I am fond of seeing being merged.
> 
> It is also true that sorting out 8250.c and by extension the other
> serial drivers that have cloned it is the significant non-arch
> piece of work needed to kill NR_IRQs

Lets just make it happen next week. It needs doing and while it wasn't
top of the serial work list this is a good reason to kill it off.

Alan
