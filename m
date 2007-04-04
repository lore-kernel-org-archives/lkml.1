Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbXDDQWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbXDDQWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXDDQWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:22:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56058 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752185AbXDDQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:22:49 -0400
Date: Wed, 4 Apr 2007 17:25:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Theodore Tso <tytso@mit.edu>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, paulus@samba.org, flar@allandria.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404172514.5ae95e60@the-village.bc.nu>
In-Reply-To: <4613CF6A.2090407@zytor.com>
References: <1175663999.2932.8.camel@shinybook.infradead.org>
	<17939.15726.114059.679277@cargo.ozlabs.ibm.com>
	<1175666635.2932.17.camel@shinybook.infradead.org>
	<20070404.011208.120446173.davem@davemloft.net>
	<20070404083803.GA13134@flint.arm.linux.org.uk>
	<20070404122154.GF31973@thunk.org>
	<4613CF6A.2090407@zytor.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> One option would be to move the 8250-based serial ports, to, say, 
> /dev/ttyN* (for National Semiconductors -- the best I could come up 
> with) and redefine /dev/ttyS* as a serial port multiplexer which maps in 
> all the types, for the ones that really want dynamic mapping.

I think this makes it worse than simply starting the 8250 ports at a
platform specific minor offset.

Alan
