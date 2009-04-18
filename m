Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZDRKu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZDRKu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 06:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZDRKus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 06:50:48 -0400
Received: from ppp-110-141.adsl.restena.lu ([158.64.110.141]:55653 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbZDRKus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 06:50:48 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Apr 2009 06:50:47 EDT
Date: Sat, 18 Apr 2009 12:44:15 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Linux IDE <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux SCSI <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/2] Stop disks on reboot for laptop which cuts power
Message-ID: <20090418124415.1dc82273@neptune.home>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During shutdown (power off) the disks are stopped gracefully thus the
stopping is skipped for reboot case.

On my Acer Travelmate 660 reboot is more like power-off as it cuts all
power during reboot which currently causes the disk to emergency-park
its head (noisy and shortens disk life).

This patch series adds a DMI-based check to ide-gd and sd to still
stop the disks for affected laptop during reboot.

Has been compile an run-tested with libata and just compile-tested for
ide.

Bruno Prémont
