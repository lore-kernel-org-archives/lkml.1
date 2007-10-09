Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbXJIMbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbXJIMbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 08:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXJIMaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 08:30:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33695 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbXJIMav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 08:30:51 -0400
Date: Tue, 9 Oct 2007 13:35:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Escaping the arguments of kernel messages for sane
 user-space localisation
Message-ID: <20071009133551.2aa672da@the-village.bc.nu>
In-Reply-To: <1191928483.17405.15.camel@grianne>
References: <1191872730.27240.29.camel@grianne>
	<1191928483.17405.15.camel@grianne>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have now found what I think is another valid use. What I have done is
> to make xprintf() emit the output directly to the kernel ring-buffer.

Thats nice.

> There is only one very small caveat (that I can see) to be mentioned:
> You can still use multiple printk() calls to append new text to a
> partial message, but you can NOT output several messages in a single
> call. I think, however, that no sanely written code would do this

A quick search suggests otherwise (eg intel_rng)


Alan
