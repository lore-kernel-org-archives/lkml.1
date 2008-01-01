Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYAAVf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYAAVf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYAAVfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:35:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58492 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754670AbYAAVfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:35:50 -0500
Date: Tue, 1 Jan 2008 21:26:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christer Weinigel <christer@weinigel.se>,
       "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101212632.04d7a497@the-village.bc.nu>
In-Reply-To: <20080101210143.GB759@elte.hu>
References: <47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101183238.74307174@weinigel.se>
	<20080101184659.GA9250@elte.hu>
	<20080101203518.26e889f2@weinigel.se>
	<20080101210143.GB759@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> very much care about code size. But it has been stated in this thread 
> that most of the _p() API uses in the kernel today are bogus. So 

You missed a word "wrongly". It has been "wrongly stated"

I've been going through the ISA cases which are the majority. Generally
speaking they are correct. We have a couple of "interesting" PCI users
who most definitely want udelay() or removal of _p. We have various
chipset cases which want looking at in detail. The ISA drivers however
are both the main user and mostly right.

> ok, "I dont know but it might be slower" is a perfectly fine statement 
> instead of your original "it will be slower".

If you use wall clock timings it will be slower.

Alan
