Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXBKCke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXBKCke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 21:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXBKCke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 21:40:34 -0500
Received: from userg501.nifty.com ([202.248.238.81]:27509 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXBKCkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 21:40:33 -0500
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	b=Bxe4yxLJ6pWApRoPKiQkEZ0XVSUPNMIh1V67s5SAo4Vt2t5L+jPX1MO9why3AYPED
	d2ga0o79FKOaHpC2/txHQ==
Date: Sun, 11 Feb 2007 11:40:13 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-Id: <20070211114013.65b2be2c.komurojun-mbn@nifty.com>
In-Reply-To: <20070211101537.e40fa309.komurojun-mbn@nifty.com>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> [pata_pcmcia dmesg]
>> ata1.00: CFA, max PIO0, 20480 sectors: LBA 
>> ata1.00: ata1: dev 0 multi count 0
>> ata1.01: CFA, max PIO0, 20480 sectors: LBA 
>> ata1.01: ata1: dev 1 multi count 0

>Do you have two cards here ?

No. one card.
I am not sure why two devices are detected.


Actually, this card works properly with ide-cs driver.
but it displays some warning message.


hde: SunDisk SDP5-10, CFA DISK drive
hdf: SunDisk SDP5-10, CFA DISK drive
ide-probe: ignoring undecoded slave
ide2 at 0xd100-0xd107,0xd10e on irq 3
hde: max request size: 128KiB
hde: 20480 sectors (10 MB) w/1KiB Cache, CHS=320/2/32
 hde:hde: set_geometry_intr: status=0x51 { DriveReady SeekComplete Error }
hde: set_geometry_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hde1
ide-cs: hde: Vpp = 0.0


Best Regards
Komuro
