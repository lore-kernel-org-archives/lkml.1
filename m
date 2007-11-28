Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbXK1WQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbXK1WQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbXK1WQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:16:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60143 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757621AbXK1WQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:16:08 -0500
Date: Wed, 28 Nov 2007 22:12:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2: Result: hostbyte=0x01
 driverbyte=0x00\nend_request: I/O error
Message-ID: <20071128221238.4a5ee8bb@the-village.bc.nu>
In-Reply-To: <20071128134036.417b3def.akpm@linux-foundation.org>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<20071128200130.GA13361@martell.zuzino.mipt.ru>
	<20071128134036.417b3def.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > [  225.378426] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.378659] end_request: I/O error, dev sdb, sector 141295703
> > [  225.390133] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.391988] end_request: I/O error, dev sdb, sector 141295703
> > [  225.392463] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.392625] end_request: I/O error, dev sdb, sector 141295703
> > [  225.392999] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.393161] end_request: I/O error, dev sdb, sector 141295703
> > [  225.393571] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.393731] end_request: I/O error, dev sdb, sector 141295703
> > [  225.394382] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.394544] end_request: I/O error, dev sdb, sector 141295703
> > [  225.395247] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.395412] end_request: I/O error, dev sdb, sector 141295703
> 
> I don't know whether this failure was a scsi thing or an ata thing?

The ATA layer would print diagnostics if it failed the command so I'm a
bit baffled by the report. It looks like the SCSI mid layer rejected it
before we even got it ?
