Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZBEI24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZBEI24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZBEI2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:28:46 -0500
Received: from edu.joroinen.fi ([194.89.68.130]:49123 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZBEI2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:28:46 -0500
Date: Thu, 5 Feb 2009 10:28:43 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Subject: Suggestions for debugging ata_piix and ahci driver failures on Xen pv_ops dom0 kernel (2.6.29-rcX)
Message-ID: <20090205082843.GD15052@edu.joroinen.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm trying to figure out what's wrong with the pv_ops dom0 kernel/patches [1]
causing at least ata_piix and ahci drivers to fail to work.

There was legacy IRQ enabling problem earlier with the pv_ops dom0 patches, 
which pretty much prevented the disks from being detected.. but that got fixed. 
It could still be something related to Xen/dom0 irq handling.. 

I'd be glad if someone could take a look at this 2.6.29-rc3-tip pv_ops dom0 kernel boot log
and comment about _possible_ causes for such behaviour of ata_piix and ahci:

http://pasik.reaktio.net/xen/pv_ops-dom0-debug/pv_ops-dom0-bootlog-11-xen331-linux-2.6.29-rc3-atadebug3.txt

In that testing box I have just one IDE hdd attached to ata_piix controller, the AHCI controller doesn't
have any disks attached.

The exact same kernel works OK without problems on baremetal without Xen
hypervisor. 

[1] http://xenbits.xen.org/paravirt_ops/patches.hg/ and
http://wiki.xensource.com/xenwiki/XenParavirtOps

-- Pasi
