Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXJJI2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXJJI2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 04:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXJJI2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 04:28:48 -0400
Received: from mail.dbmail.dk ([82.143.192.7]:6581 "EHLO mail.dbmail.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbXJJI2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 04:28:47 -0400
Message-ID: <56020.194.255.108.253.1192004925.squirrel@root.dusted.dk>
Date: Wed, 10 Oct 2007 10:28:45 +0200 (CEST)
Subject: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
From: lists@dusted.dk
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get this on brand new hardware, 2xHitachi Deathstar 320gb SATA2
(sata_via driver)

I get this a lot, the disk makes some sound after heavy IO and then the
system hangs for a few seconds, then this comes up:

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd 25/00:00:3f:76:30/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: soft resetting port
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
raid1: Disk failure on sdb1, disabling device.

This is on kernel 2.6.23

