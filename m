Return-Path: <linux-kernel-owner+w=401wt.eu-S1763609AbXIUVoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763609AbXIUVoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761314AbXIUVn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:43:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466AbXIUVn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:43:56 -0400
Message-ID: <46F43B18.4090306@redhat.com>
Date: Fri, 21 Sep 2007 17:43:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-scsi <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, megaraidlinux@lsi.com,
       djabbour@intronis.com
Subject: Megaraid driver not detecting RAID volumes in kernel 2.6.22?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=288421

When running Fedora on a Dell 2950 w/ integrated LSI Perc5i (megaraid), the
system will not boot after upgrading to 2.6.22.  The boot message indicates the
system is somehow seeing through RAID, cannot access logical volume.  This
causes the root device to be unavailable and the kernel to panic.

Version-Release number of selected component (if applicable):
I experience this problem with kernel 2.6.22 and higher.  I do not believe it is
isolated to FC6, as I downloaded the stock 2.6.22 kernel from kernel.org and was
able to reproduce.

How reproducible:
Every time.

Steps to Reproduce:
1. Configure RAID10 (I've also tried RAID5) on a Perc5i in this system.

2. Load Fedora Core.  The installer works fine since the kernel version it uses
has a working LSI driver.

3. Upgrade to 2.6.22 kernel image (in yum) or download kernel.org sources,
compile, and install.

4. Reboot system.  It comes up unable to boot.  The kernel panics.
  
Actual results:
As the system boots, it cannot mount the root device.  Also in the output we see
all 6 disks separately, when they should be showing up as one logical volume.

