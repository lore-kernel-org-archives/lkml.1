Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbXFOXGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbXFOXGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbXFOXGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:06:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47191 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753534AbXFOXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:06:22 -0400
Date: Sat, 16 Jun 2007 00:11:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk,
       James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Message-ID: <20070616001102.3d2fa850@the-village.bc.nu>
In-Reply-To: <20070615.141917.85409547.davem@davemloft.net>
References: <1181918159.25228.543.camel@pmac.infradead.org>
	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	<20070615171545.316dfac7@the-village.bc.nu>
	<20070615.141917.85409547.davem@davemloft.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That sounds like a good idea for my virtual I/O case on
> Niagara too actually :-)

It was actually meant semi-seriously in that drivers/ata sits on top of
the abstract parts of drivers/scsi which James keeps asking for someone to
get split properly off and which would sort all these out.

> Another quirk I have to deal with is that under LDOMs you
> can export full disks and also just slices.  So I'll have
> to get down into the partition machinery to support that
> somehow.

If your slices don't fit the PC worldview you might want to look at
dmraid and just use device mapper to handle them. It is a lot more
flexible and we could actually bin all our partition code and use this
but for back compatibility.

Alan
