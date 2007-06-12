Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbXFLKjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbXFLKjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXFLKjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:39:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47376 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501AbXFLKjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:39:37 -0400
Date: Tue, 12 Jun 2007 11:43:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
Message-ID: <20070612114345.07ab60f6@the-village.bc.nu>
In-Reply-To: <466E65A7.3000206@msgid.tls.msk.ru>
References: <466E65A7.3000206@msgid.tls.msk.ru>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 13:21:43 +0400
Michael Tokarev <mjt@tls.msk.ru> wrote:

> I bought a VIA PC2500 board a few days ago - this
> new series of their mobos,
> 
> This beast looks nice - after replacing their cooling
> system (that had a small fan on it) with larger but
> fanless, -- it becomes a almost real PC (1500MHz CPU),
> equipped with quite nice crypto and multimedia abilities,
> but with very low power consumption and very quiet.
> 
> But the thing is - it doesn't quite work.

That is usually memory or motherboard timings. memtest86+ will miss a lot
of problems on these boards for some reason I don't really fathom
although its still a worthwhile test you did

I'd be interested to knowwhat the following do


Bad RAM check:
	Boot with mem= to limit to the bottom 256MB of RAM
	(Windows tends to use different areas of RAM to Linux the most so
	your report fits that)

Stress testing:
	Go into X in a high resoution, starting running a continuous
	copy to or from disk and see if its suddenely much less stable

Disabling power management

