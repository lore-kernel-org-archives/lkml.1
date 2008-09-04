Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYIDKKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYIDKKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYIDKKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:10:05 -0400
Received: from stargate.synerway.com ([84.14.10.249]:43687 "EHLO
	kamino.synerway.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbYIDKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:10:04 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 06:10:03 EDT
Date: Thu, 4 Sep 2008 11:54:47 +0200
From: Pascal GREGIS <pgs@synerway.com>
To: linux-kernel@vger.kernel.org
Subject: SCSI or libata problem with an RDX removable disk
Message-ID: <20080904095447.GE2814@venus.synerway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-OriginalArrivalTime: 04 Sep 2008 09:54:47.0818 (UTC) FILETIME=[4417DEA0:01C90E74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I turn to you with a new problem about scsi or libata.
I have a removable disk of type RDX, connected by SATA to my linux machine.
I access it via libata on /dev/sdb, like a classical disk.
I write to it a certain time with some mounts and umounts.
After a certain number of mounting and unmounting, or maybe a certain number of hours (not clearly identified), the device refuses to be mounted, saying "You must specify the filesystem type.".
Looking to /var/log/messages I have the following logs :


Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] READ CAPACITY failed
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Sense not available.
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Write Protect is off
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 00 00 00
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Asking for cache data failed
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Assuming drive cache: write through
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] READ CAPACITY failed
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Sense not available.
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Write Protect is off
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 00 00 00
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Asking for cache data failed
Jul 15 14:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Assuming drive cache: write through

These lines are logged again when I run cfdisk or parted or hdparm or anything
on /dev/sdb.

My system is :
linux kernel 2.6.21.1 with some patches :
- libata-start_stop_management (http://bugs.gentoo.org/attachment.cgi?id=118829)

compiled with libata.

Motherboard ICH6 family (id 2651)

Does anyone know this problem or have an idea about what it is and what to do?

Thank you in advance

Pascal
