Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXH2Qio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXH2Qio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXH2Qie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:38:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59565 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752974AbXH2Qid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:38:33 -0400
Date: Wed, 29 Aug 2007 17:46:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady
 SeekComplete Error }
Message-ID: <20070829174657.09c7de3c@the-village.bc.nu>
In-Reply-To: <46D59ED2.4000900@free.fr>
References: <46D59ED2.4000900@free.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Standards:
>          Likely used: 1

Prehistory

>          LBA, IORDY not likely

No DMA, nothing above PIO2

>          Buffer type: 0002: dual port, multi-sector
>          Buffer size: 1.0kB      bytes avail on r/w long: 4
>          Cannot perform double-word IO

Can't even do double word I/O

The messages with old IDE should be harmless and the current libata IDE
should drive it politely (I debugged a problem the same hardware showed
up for someone else).

Basically your dinosaur is working correctly.

Alan
