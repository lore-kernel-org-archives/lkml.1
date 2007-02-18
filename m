Return-Path: <linux-kernel-owner+w=401wt.eu-S1030294AbXBRF0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030294AbXBRF0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 00:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXBRF0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 00:26:47 -0500
Received: from temporal.lostlogicx.com ([82.165.156.221]:46115 "EHLO
	temporal.lostlogicx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030296AbXBRF0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 00:26:47 -0500
X-Greylist: delayed 1820 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Feb 2007 00:26:47 EST
Date: Sat, 17 Feb 2007 22:56:25 -0600
From: Brandon Low <lostlogic@lostlogicx.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20: libata PATA ATAPI CDROM weirdness on ALI
Message-ID: <20070218045625.GE19788@lostlogicx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux temporal 2.6.18.5
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having some weirdness during boot with my optical drives on 2.6.20.

ata2.00: ATAPI, max UDMA/33     
ata2.01: ATAPI, max UDMA/33 
ata2.00: qc timeout (cmd 0xef)
ata2.00: failed to set xfermode (err_mask=0x4)
ata2.00: limiting speed to UDMA/25
ata2: failed to recover some devices, retrying in 5 secs
ata2.00: configured for UDMA/25
ata2.01: configured for UDMA/33

the 4 lines starting with qc timeout _would_ repeat with lower speeds
until the drive was finally disabled and then do the same for 2.01,
except that on this particular attempt, I had the thought to eject both
optical drives while it sat there.  Boot then proceeded normally and the
drives appear to work.

Intuitively this seems to indicate that the drives aren't being sent
some kind of wake-up call before their transfer modes are set.

The motherboard is an ASRock 939 Dual SATA II.

Let me know if there is any more information that I can provide.

Thanks,

Brandon Low
