Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXKMVXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXKMVXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759796AbXKMVXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:23:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35720 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759677AbXKMVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:23:09 -0500
Date: Tue, 13 Nov 2007 21:22:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
Message-ID: <20071113212230.77cadecd@the-village.bc.nu>
In-Reply-To: <20071113164323.GA5252@section-eight>
References: <20071113164323.GA5252@section-eight>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> while trying to limit the speed of DVD drives during DVD playback I've
> come under the impression that GPCMD_SET_STREAMING via SG_IO doesn't yet
> work with libata/PATA (AMD/NVIDIA PATA support). I tested on an NForce2
> board (all IDE, no SATA) and kernel 2.6.22.12. When I use the "old" ATA
> kernel driver my drive slows down, with libata it doesn't. Is this a
> known issue or has this slipped by unnoticed?

It isn't a known issue, and it suprises me as SG_IO basically passes
commands through to the drive. We don't support speed change via xfermode
setting but GPCMD_SET_STREAMING sohuld behave.

> 
> I tried with mplayer dvd:// -dvd-device /dev/sr0 -dvd-speed BTW . I get
> no errors in syslog/dmesg. Also mplayer doesn't report a problem (so
> ioctl(fd, SG_IO, &sghdr) doesn't have a return < 0).

Do you have a simple code example that shows the problem ?
