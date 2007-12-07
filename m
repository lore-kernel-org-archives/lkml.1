Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbXLGAVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbXLGAVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXLGAVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:21:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60902 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752298AbXLGAVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:21:14 -0500
Date: Fri, 7 Dec 2007 00:15:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071207001533.7737ecf5@the-village.bc.nu>
In-Reply-To: <475879CD.9080006@reed.com>
References: <475879CD.9080006@reed.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Changing the delay instruction sequence from the outb to short jumps 
> might be the safe thing.  But Linus, et al. may have experience with 
> that on other architectures like older Pentiums etc.

Post boot we can use udelay() for this. Earlier I guess we could use
udelay and make sure it starts "safe" before we know the timing.

Alan
