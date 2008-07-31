Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYGaOd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYGaOd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYGaOdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:33:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44756 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755904AbYGaOdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:33:13 -0400
Date: Thu, 31 Jul 2008 14:57:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: change remove NR_IRQS in 8250.c
Message-ID: <20080731145752.2aec5727@lxorguk.ukuu.org.uk>
In-Reply-To: <m1iqum2rya.fsf@frodo.ebiederm.org>
References: <200807291414.55479.yhlu.kernel@gmail.com>
	<200807302109.21519.yhlu.kernel@gmail.com>
	<200807302110.10585.yhlu.kernel@gmail.com>
	<200807310126.12572.yhlu.kernel@gmail.com>
	<m1iqum2rya.fsf@frodo.ebiederm.org>
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

On Thu, 31 Jul 2008 04:50:21 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> > replace
> > 	[PATCH] serial: change irq_lists to use dyn_array
> > use small array with index to handle irq locking for serial port
> > hope 32 slot is enough
> 
> Could you size this array by NR_UARTS (our worst case usage)
> and place irq_no in struct irq_info?

NR_UARTS is likely to go away in time so don't get attached to it
