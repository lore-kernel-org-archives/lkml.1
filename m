Return-Path: <linux-kernel-owner+w=401wt.eu-S1764600AbYBLXN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764600AbYBLXN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762800AbYBLXL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:11:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42928 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760523AbYBLXLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:11:55 -0500
Date: Tue, 12 Feb 2008 23:01:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       davem@davemloft.net, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212230132.2ea5befd@core>
In-Reply-To: <20080212224103.GK27894@ZenIV.linux.org.uk>
References: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	<1202838082.3137.54.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	<1202840682.3137.83.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
	<alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
	<20080212194100.GH27894@ZenIV.linux.org.uk>
	<20080212215152.1470fe7f@core>
	<20080212141726.1e214729.akpm@linux-foundation.org>
	<20080212222044.214ad821@core>
	<20080212224103.GK27894@ZenIV.linux.org.uk>
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

> Hrm...  How badly is pl2303 broken?  I actually use that sucker, so if
> it needs help - count me in.

2303 is pretty good (in fact by usb serial standards outstanding). It has
all the internal locking needed for now and right down to killing
lock_kernel entirely outside of open/close (which is going to hit
everything).

Only fixme I have tagged for it is

- if you set an unsupported baud rate it reports it set rather than the
one you got

Which is a trivial mend for someone who has suitable docs (its marked
FIXME: at the right spot)
