Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbXLJTmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbXLJTmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXLJTmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:42:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51539 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754335AbXLJTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:42:47 -0500
Date: Mon, 10 Dec 2007 19:37:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Rajula <chris@nerdmail.nu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compile error: patched 2.6.23-r3 with rr2310_00 drivers
Message-ID: <20071210193717.4cc3bcf2@the-village.bc.nu>
In-Reply-To: <475D95B5.9000905@nerdmail.nu>
References: <475D95B5.9000905@nerdmail.nu>
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

>       CC      drivers/scsi/rr2310_00/os_linux.o
>     drivers/scsi/rr2310_00/os_linux.c: In function 'os_sd_changed':
>     drivers/scsi/rr2310_00/os_linux.c:315: error: implicit declaration
>     of function 'scsi_device_cancel'
>     make[3]: *** [drivers/scsi/rr2310_00/os_linux.o] Error 1
>     make[2]: *** [drivers/scsi/rr2310_00] Error 2
>     make[1]: *** [drivers/scsi] Error 2
>     make: *** [drivers] Error 2
> 
> 
> 
> The same driver patched onto the 2.6.22 kernel compiles.
> 
> Is this a linux specific bug, or are the drivers from Highpoint-tech 
> simply outdated?

The report should go to highpoint tech.

The Linux community is working on adding Highpoint 23xx support to the
standard sata_mv drivers, but HPT don't appear to document a lot of the
raid layout they use and hide it in a binary object module which makes it
somewhat problematic.

Alan
