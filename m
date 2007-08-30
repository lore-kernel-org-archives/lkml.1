Return-Path: <linux-kernel-owner+w=401wt.eu-S1764309AbXH3XXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764309AbXH3XXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763239AbXH3XXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 19:23:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52470 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762922AbXH3XW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 19:22:59 -0400
Date: Fri, 31 Aug 2007 00:31:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady
 SeekComplete Error }
Message-ID: <20070831003127.6f6950f4@the-village.bc.nu>
In-Reply-To: <46D6DDF6.6080400@free.fr>
References: <46D59ED2.4000900@free.fr>
	<20070829174657.09c7de3c@the-village.bc.nu>
	<46D67D09.6090101@free.fr>
	<46D69E03.9080403@vc.cvut.cz>
	<46D6B85C.5050509@free.fr>
	<46D6DDF6.6080400@free.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> PIO mode 2 is mentioned. Even DMA seems to be supported.
> Or am I mistaken?
> 
> Could there be a bug in my south bridge?

Nothing there about DMA support.

The data sheet says the media can only do 4.1MB/second which is
consistent with only needing PIO2 (actually its far slower than PIO2)

