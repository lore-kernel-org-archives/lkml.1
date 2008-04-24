Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYDXVOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYDXVOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYDXVNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:13:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33265 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752925AbYDXVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:13:54 -0400
Date: Thu, 24 Apr 2008 21:44:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, paulkf@microgate.com,
       jchapman@katalix.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
Message-ID: <20080424214457.1d5a1655@the-village.bc.nu>
In-Reply-To: <m3ve27nfpx.fsf@maximus.localdomain>
References: <m3r6cv75xq.fsf@maximus.localdomain>
	<20080424.063006.153647297.davem@davemloft.net>
	<m3mynj74nw.fsf@maximus.localdomain>
	<20080424.065555.30390704.davem@davemloft.net>
	<m3ve27nfpx.fsf@maximus.localdomain>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it's easier to a) simply remove syncppp.c, b) apply my patch
> with new PPP, c) blindly port the old drivers to generic HDLC,
> d) hope for the best, with a bit of luck nobody would notice.

I would agree with this. There isn't a sane way to sort out the old
kernel side syncppp (which is useless for todays networks as it doesn't
do compression, IPv6 or auth protocols) except by going to user space.
