Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXHaLmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXHaLmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXHaLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:41:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41804 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965093AbXHaLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:41:29 -0400
Date: Fri, 31 Aug 2007 12:49:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady
 SeekComplete Error }
Message-ID: <20070831124958.6f2104ec@the-village.bc.nu>
In-Reply-To: <46D7CFD7.9030404@free.fr>
References: <46D59ED2.4000900@free.fr>
	<20070829174657.09c7de3c@the-village.bc.nu>
	<46D67D09.6090101@free.fr>
	<46D69E03.9080403@vc.cvut.cz>
	<46D6B85C.5050509@free.fr>
	<46D6DDF6.6080400@free.fr>
	<20070831003127.6f6950f4@the-village.bc.nu>
	<46D7CFD7.9030404@free.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When a DMA operation is enabled, CS0- and CS1- shall not be asserted and 
> transfers shall be 16-bits wide.
> 
> I took the above to mean the device was designed to support DMA.
> Where did I err?

The bus is specified for DMA, not the device.

> 
> > The data sheet says the media can only do 4.1MB/second which is
> > consistent with only needing PIO2 (actually it's far slower than PIO2)
> 
> Is such a slow speed typical of DOMs sold today?
> 
> Or do DOMs sold today support DMA bus mastering, much higher interface 
> rates, and much higher sustained throughput?

Most CF is pretty slow but the newer CF cards do DMA and are getting far
better.

And yes I'd expect your real time app to deal for 3 or 4mS

(Mind you you'll get 1mS normal operating worst cases off even a fast DMA
IDE disk)
