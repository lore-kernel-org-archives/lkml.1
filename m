Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbXBJRdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbXBJRdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXBJRdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:33:03 -0500
Received: from tag.witbe.net ([81.88.96.48]:53267 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXBJRdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:33:01 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Robert Hancock'" <hancockr@shaw.ca>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: AHCI - remove probing of ata2
Date: Sat, 10 Feb 2007 18:32:02 +0100
Organization: AS2917.net
Message-ID: <00ba01c74d39$604fddf0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <45CDFECC.5060500@shaw.ca>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdNN7sLUrn+rpIGROWi4ShTlWpQ2wAARfXw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> There is something connected, I believe what's actually there on this 
> board on that port is the SiI4723 chip which is connected to 
> two other 
> SATA ports. For whatever reason it gets detected as a drive, 
> and it also 
> seems to be not responding until we do a few resets..

That's correct, there is this controller, used by Asus for their EZ-Backup
feature. But I'm not using it, there is no disk connected on the associated
ports, and it's disabled in the BIOS.

> My advice on recent kernels is just set CONFIG_IDE=n and enable 
> PATA_JMICRON if you want JMicron support, unless you really 
> want to use the crusty old IDE layer..

No real preferences... except for a working machine, which is not what
I have for now...

I've been trying this, but I ended with the ICH7 not detecting anymore
my IDE disks... 
Should try again, maybe I missed something.

Regards,
Paul

