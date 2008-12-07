Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYLGSQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYLGSQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYLGSPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:15:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52286 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752467AbYLGSPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:15:51 -0500
Date: Sun, 7 Dec 2008 18:15:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<20081207163151.GA31838@ioremap.net>
	<20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	<ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	<20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	<20081207174435.GB1687@ioremap.net>
	<20081207175245.2d074299@lxorguk.ukuu.org.uk>
	<20081207175438.GA3181@ioremap.net>
	<20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	<ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, log nowhere instead of running in a loop would be much better
> than loading a 5:1 driver which will never exist as a module.

The loop is detected and terminated.
> 
> > Why is this useful - you now get failing module loads producing no
> > diagnostics and in many case the setup just dying silently.
> 
> It's obviously more useful than not to boot up.

What makes you think it will now boot up. The loop is already detected
and terminated. What will you do if it doesn't and you get no
diagnostics. How will distributions debug those reports in bugzilla.

> No, the pci driver will never get loaded by modprobe 5:1,

Why not ? You have no idea how the other millions of Linux users have
their module loading rules configured. A change which breaks this
behaviour is a regression.

Alan
