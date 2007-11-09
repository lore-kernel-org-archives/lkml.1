Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXKITGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXKITGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 14:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbXKITGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 14:06:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35545 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751238AbXKITGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 14:06:04 -0500
Date: Fri, 9 Nov 2007 19:04:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernd Strieder <strieder@informatik.uni-kl.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64 SATA DVD drive + libata trouble
Message-ID: <20071109190413.0efe9318@the-village.bc.nu>
In-Reply-To: <200711091933.01523.strieder@informatik.uni-kl.de>
References: <200711091933.01523.strieder@informatik.uni-kl.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a Tyan mainboard with NVIDIA chipset CK804. The only 
> SATA/IDE device is a SATA DVD combo, the harddisks are on a RAID 
> controller from 3ware. The harddisks are fine.

Interesting. I have only one other report of this problem that resembles
yours. They also have a 3ware raid controller. 

> installation kernel cannot use the DVD drive. That kernel uses 
> libata and sata_nv pata_amd as drivers. The drive is recognized 

These are the correct drivers.

> A vanilla 2.6.23.1 kernel behaves even less friendly, the dd 
> on /dev/sr0 causes a hard reset.

A dmesg and further info would be useful here. Also knowing how much
memory your system has and whether it passes memtest86.

> So there are clearly some problems with libata in this system.

CK804 is known to work reliably. That means we are looking for something
thats "different" about your system - perhaps the devices, the amount of
memory etc. 

Alan
