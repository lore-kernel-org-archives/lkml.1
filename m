Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYHPP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYHPP57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 11:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYHPP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 11:57:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40366 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752167AbYHPP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 11:57:50 -0400
Date: Sat, 16 Aug 2008 16:39:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Message-ID: <20080816163945.74d487e9@lxorguk.ukuu.org.uk>
In-Reply-To: <1218898238.3940.6.camel@localhost.localdomain>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	<86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	<1218898238.3940.6.camel@localhost.localdomain>
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

> Where exactly is this code in the kernel?  Most arches assume the irq is
> an index to a compact table bounded by NR_IRQS, so something like this
> would violate that assumption.

Yes, which is no bad thing for some platforms. There are some driver
assumptions like that but those have also been stomped.

Alan
