Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbYEFWTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbYEFWTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYEFWTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:19:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56117 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379AbYEFWT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:19:29 -0400
Date: Tue, 6 May 2008 23:09:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Yigal Sadgat" <YSadgat1@gcte.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <jwboyer@linux.vnet.ibm.com>, <joern@logfs.org>
Subject: Re: Compact Flash Question
Message-ID: <20080506230954.6e034cba@core>
In-Reply-To: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
References: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (1) Can you really ignore bit(2) (CORR) in the Status register offset 7 that 
> tells
> you that the CF has detected and corrected a soft error?, etc.

I guess it might be interesting to log the error rate but we don't
currently do that. A corrected error is just that however - corrected by
the card itself.

> (2) An engineer at SanDisk Engineering told me NOT to do wear leveling.
> The file allocation table is written very frequently back into the flash. So
> is it really safe to assume that I don't need wear leveling???

Depends on your hardware vendor. Wear management is done within the CF
card and only the hardware vendor can tell you what they do. 

> (3) Re. the BUSY bit in the status register (offset 7, bit D7), anybody 
> experienced
> time outs?

Yes - both from failing CF cards and also other random events (bad
connections, people removing live cards etc)

> (4) Re Error register (offset 1) bit D7 (BBK), again, I was told that it 
> cannot (???)
> happen since the CF performs read-after-write and it automatically switches 
> good blocks
> for bad ones... Is this correct?

Depends on your hardware vendor. It certainly *can* occur with some CF
cards perhaps when they run out of spare blocks.

Alan
