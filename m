Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbXDJTRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbXDJTRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXDJTRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:17:52 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:46229 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbXDJTRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:17:40 -0400
Date: Tue, 10 Apr 2007 21:17:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/30] Use menuconfig objects
Message-ID: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,


the following patch series turns some menus into menuconfigs, so they 
can be disabled whilst "walking" thorugh the parent menu (check the 
videos [1], [2] to see what I mean), enabling for disabling lots of 
options _quickly_.

I'll send the patches (as a reply to this mail) piece by piece out
when I figure out the maintainers to Cc for each.

[1] 6.04 MB(1000s) 70 sec http://jengelh.hopto.org/mc/without.ogg
[2] 1.96 MB(1000s) 44 sec http://jengelh.hopto.org/mc/with.ogg
(Ogg container, Theora Video, no audio)

I have not poked on all subsystems (it is quite a lot), but I can 
already give a glimpse (`ls -1`) of who gets one and who does not.
And, I am not completely finished changing some subsystems - but
the patches are already big enough for a first wave. I want to get
some feedback first. Thanks!

`ls -1`:
	menuconfig-acpi.diff
	menuconfig-apm.diff
	menuconfig-ata.diff
	menuconfig-block.diff
	menuconfig-connector.diff
	menuconfig-crypto.diff
	menuconfig-crypto2.diff
	menuconfig-dccp.diff
	menuconfig-fusion.diff
	menuconfig-i2c.diff
	menuconfig-i2o.diff
	menuconfig-ide.diff
	menuconfig-ieee1394.diff
	menuconfig-md.diff
	menuconfig-modules.diff
	menuconfig-mtd.diff
	menuconfig-net-ipvs.diff
	menuconfig-net-sctp.diff
	menuconfig-net-tipc.diff
	menuconfig-netdev-arcnet.diff
	menuconfig-netdev-phy.diff
	menuconfig-netdev-tr.diff
	menuconfig-netdev.diff
	menuconfig-oldcd.diff
	menuconfig-parport.diff
	menuconfig-pcihotplug.diff
	menuconfig-pcmcia.diff
	menuconfig-pnp.diff
	menuconfig-scsi.diff
	menuconfig-w1.diff



Jan
-- 
