Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbXGLHic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbXGLHic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbXGLHiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:38:23 -0400
Received: from ptb-relay02.plus.net ([212.159.14.213]:33056 "EHLO
	ptb-relay02.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbXGLHiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:38:22 -0400
X-Greylist: delayed 3456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 03:38:22 EDT
Subject: Hard drive - dead or dying?
From: David Sumbler <david@aeolia.co.uk>
Reply-To: david@aeolia.co.uk
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 12 Jul 2007 07:40:44 +0100
Message-Id: <1184222444.5969.0.camel@ceres>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My computer (Ubuntu Feisty) would not boot correctly a few days
ago: it seemed to get into a loop with the following printed about
every 7 seconds (all laboriously copied in longhand, since it wasn't
logged!):

ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.01: (BMDMA stat 0x65)
ata1.01: cmd c8/00:08:80:b4:a8/00:00:00:00:00/f4 tag0 cdb 0x0 data 4096
in
         res 51/01:08:80:b4:a8/00:00:00:00:00/f4 Emark 0x1 (device
error)
ata1.01: ata_hpa_resize 1: sectors = 78165360, hpa_sectors : 78165360
ata1.00: ata_hpa_resize 1: sectors = 160086528, hpa_sectors : 160086528
ata1.00: configured for UDMA/33
ata1.01: ata_hpa_resize 1: sectors = 78165360, hpa_sectors : 78165360
ata1.01: configured for PIO3
ata1.01: EH complete

Periodically there would be other messages.

Most of this means nothing to me, but after several attempts I concluded
that ata1.00 probably refers to /dev/sda, and ata1.01 to /dev/sdb, and
that there was a fault with the second.

I disconnected the drive, and the computer booted OK.  I have now
commented out references to the partitions on /dev/sdb in /etc/fstab.

The drive in question was giving minor problems a couple of years ago,
and on advice I bought a new one, but kept the old one for backups
etc.  Until now, it seems to have behaved pretty well.

Can someone tell me this: has the drive now as-good-as died, or is there
any hope of resurrection?

David

-- 
David Sumbler <david@aeolia.co.uk>

