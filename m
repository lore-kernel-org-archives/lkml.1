Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbXDMJvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbXDMJvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXDMJvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:51:38 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:4740 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752929AbXDMJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:51:38 -0400
Date: Fri, 13 Apr 2007 11:50:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Use menuconfig objects
Message-ID: <20070413115036.1be7c595@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

On Tue, 10 Apr 2007 21:17:40 +0200 (MEST), Jan Engelhardt wrote:
> the following patch series turns some menus into menuconfigs, so they 
> can be disabled whilst "walking" thorugh the parent menu (check the 
> videos [1], [2] to see what I mean), enabling for disabling lots of 
> options _quickly_.
> 
> I'll send the patches (as a reply to this mail) piece by piece out
> when I figure out the maintainers to Cc for each.
> 
> [1] 6.04 MB(1000s) 70 sec http://jengelh.hopto.org/mc/without.ogg
> [2] 1.96 MB(1000s) 44 sec http://jengelh.hopto.org/mc/with.ogg

You might want to try the -q flag of quilt push and quilt pop.

> I have not poked on all subsystems (it is quite a lot), but I can 
> already give a glimpse (`ls -1`) of who gets one and who does not.
> And, I am not completely finished changing some subsystems - but
> the patches are already big enough for a first wave. I want to get
> some feedback first. Thanks!
> 
> `ls -1`:
> 	menuconfig-acpi.diff
> 	menuconfig-apm.diff
> 	menuconfig-ata.diff
> 	menuconfig-block.diff
> 	menuconfig-connector.diff
> 	menuconfig-crypto.diff
> 	menuconfig-crypto2.diff
> 	menuconfig-dccp.diff
> 	menuconfig-fusion.diff
> 	menuconfig-i2c.diff
> 	menuconfig-i2o.diff
> 	menuconfig-ide.diff
> 	menuconfig-ieee1394.diff
> 	menuconfig-md.diff
> 	menuconfig-modules.diff
> 	menuconfig-mtd.diff
> 	menuconfig-net-ipvs.diff
> 	menuconfig-net-sctp.diff
> 	menuconfig-net-tipc.diff
> 	menuconfig-netdev-arcnet.diff
> 	menuconfig-netdev-phy.diff
> 	menuconfig-netdev-tr.diff
> 	menuconfig-netdev.diff
> 	menuconfig-oldcd.diff
> 	menuconfig-parport.diff
> 	menuconfig-pcihotplug.diff
> 	menuconfig-pcmcia.diff
> 	menuconfig-pnp.diff
> 	menuconfig-scsi.diff
> 	menuconfig-w1.diff

As far as I can see, the hwmon subsystem would benefit from that too.

-- 
Jean Delvare
