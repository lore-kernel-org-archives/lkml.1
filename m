Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYAHQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYAHQ0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbYAHQ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:26:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:45206 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbYAHQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:26:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lk0Fh7kHB+9FO+EuoFQz87NxPHW8x81j9XqX0hxJjOma1424DGOd3CFcem+xdSOljLfjEjqtXysGMKmVUhbUzDsmQHKfinIGmG/P5/mrDkeCIT+MAxOScWOaChNJKoo65joUj9fhcc3BtIS93i5ZXcirLjptU0dcPQSR3k5yvoQ=
Message-ID: <8db1092f0801080826s44582801s2dbacd02f30c7240@mail.gmail.com>
Date: Tue, 8 Jan 2008 17:26:05 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [Re: Linux 2.6.24-rc7] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this message when resume from suspend to disk:

hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
sd 0:0:0:0: [sda] Starting disk
[...]
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: configured for UDMA/133
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

Suspend to disk works fine without any problems.

Full dmesg:
http://www.unixy.pl/maciek/download/kernel/2.6.24-rc7/
