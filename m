Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYBLWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYBLWbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYBLWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:31:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46847 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753450AbYBLWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:31:04 -0500
Date: Tue, 12 Feb 2008 22:20:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
       James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       davem@davemloft.net, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212222044.214ad821@core>
In-Reply-To: <20080212141726.1e214729.akpm@linux-foundation.org>
References: <20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
	<alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	<1202838082.3137.54.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	<1202840682.3137.83.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
	<alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
	<20080212194100.GH27894@ZenIV.linux.org.uk>
	<20080212215152.1470fe7f@core>
	<20080212141726.1e214729.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the best way to get the serial drivers maintained would be to cat
> them all onto the end of synclink.c and hope that Paul thinks he did it.

Well I've already broken the buffering so he'd fix it ;)

We have a pile of old ISA drivers that are going to break soon with the
locking changes and a pile of USB drivers that when I looked at the
locking were so terminally broken I couldn't be bothered to fix them.

So it'll be fun, lots of && BROKENs to add
