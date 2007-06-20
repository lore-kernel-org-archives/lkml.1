Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbXFTQ7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbXFTQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXFTQ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:59:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36326 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752946AbXFTQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:59:24 -0400
Date: Wed, 20 Jun 2007 18:05:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timo Sirainen <tss@iki.fi>
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org
Subject: Re: SMP read() stopping at memory page boundaries
Message-ID: <20070620180500.6e2d600a@the-village.bc.nu>
In-Reply-To: <1182358622.3768.98.camel@hurina>
References: <1182351171.3768.65.camel@hurina>
	<1182354493.3768.80.camel@hurina>
	<2c0942db0706200922i15ce44b0xceaed95d002dba33@mail.gmail.com>
	<1182358622.3768.98.camel@hurina>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought this wouldn't happen when reading from local filesystems.
> Anyway, my real program was doing that, and it was still seeing partial
> data. But looks like I can't reproduce it in my test program with two
> pread()s, so I'll have to do some more debugging.

It will occur if you are reading as someone else changes the file size.
Use file locking, it exists for a reason ;)

Alan
