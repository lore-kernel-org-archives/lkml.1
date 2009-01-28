Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbZA1KNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbZA1KNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZA1KNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:13:37 -0500
Received: from mail.embedromix.ro ([82.78.144.6]:46677 "EHLO
	mail.embedromix.ro" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZA1KNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:13:36 -0500
X-Greylist: delayed 2570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2009 05:13:35 EST
Date: Wed, 28 Jan 2009 11:30:42 +0200 (EET)
From: "Catalin(ux) M. BOIE" <catab@embedromix.ro>
To: linux-kernel@vger.kernel.org
cc: linux-ide@vger.kernel.org
Subject: Seagate disk freeze for 30 seconds then comes back (RecovComm
 10B8B)
Message-ID: <alpine.LFD.2.00.0901271739400.2013@mail.embedromix.ro>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have a ST9160821AS drive, firmware 3.BHE, and I experience some seldom 
problems with it. It is in a HP 6715s HP laptop, kernel 2.6.27.5.

The error message is:
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x80002 action 0x6 frozen
ata1: SError: { RecovComm 10B8B }
ata1.00: cmd ca/00:f8:11:b8:38/00:00:00:00:00/ec tag 0 dma 126976 out
res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: hard resetting link
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA

When it happens, the system freezes for around 30 seconds.

Seagate told me that there is no firmware update for this drive.

Please, let me know if it is a software issue.

Thank you very much!

--
Catalin(ux) M. BOIE
http://kernel.embedromix.ro/
