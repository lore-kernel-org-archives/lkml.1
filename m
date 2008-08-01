Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbYHAWZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbYHAWZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbYHAWYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:24:52 -0400
Received: from sov-mail-b0016.gradwell.net ([193.84.87.40]:51425 "EHLO
	sov-mail-b0016.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141AbYHAWYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:24:51 -0400
Date: Fri, 1 Aug 2008 23:22:40 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Robert Hancock <hancockr@shaw.ca>,
       Tomas Styblo <tripie@cpan.org>, <linux-usb@vger.kernel.org>,
       <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
 device 152d:2338
Message-Id: <20080801232240.d24166de.alex.buell@munted.org.uk>
In-Reply-To: <20080801221504.49464f85.alex.buell@munted.org.uk>
References: <4890C72D.7040604@shaw.ca>
	<Pine.LNX.4.44L0.0807301700310.2322-100000@iolanthe.rowland.org>
	<20080801221504.49464f85.alex.buell@munted.org.uk>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 22:15:04 +0100, I waved a wand and this message
magically appears in front of Alex Buell:

> I've done a lot of mkfs and fsck, haven't seen any problems so far.
> Fingers crossed that this patch works. 

Spoke too soon, that patch that was posted doesn't work for me. Here's
my log:

Aug  1 23:18:08 lithium scsi 5:0:0:0: Direct-Access     SAMSUNG  SP1213C          0-30 PQ: 0 ANSI: 2 CCS
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] 234493056 512-byte hardware sectors (120060 MB)
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Write Protect is off
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Mode Sense: 00 38 00 00
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Assuming drive cache: write through
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] 234493056 512-byte hardware sectors (120060 MB)
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Write Protect is off
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Mode Sense: 00 38 00 00
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Assuming drive cache: write through
Aug  1 23:18:08 lithium sda: sda1
Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Attached SCSI disk
Aug  1 23:18:08 lithium sd 5:0:0:0: Attached scsi generic sg1 type 0
Aug  1 23:18:08 lithium usb-storage: device scan complete
Aug  1 23:19:11 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
Aug  1 23:19:11 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Aug  1 23:19:11 lithium ERROR: (device sda1): dbAllocNext: Corrupt dmap page
Aug  1 23:19:11 lithium ERROR: (device sda1): dbAllocNext: Corrupt dmap page
Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Aug  1 23:20:01 lithium cron[13504]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Aug  1 23:20:34 lithium usb 1-3.4.3: USB disconnect, address 8

:-(
-- 
http://www.munted.org.uk

Fearsome grindings.
