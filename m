Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbXJ1SwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbXJ1SwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXJ1SwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:52:06 -0400
Received: from main.gmane.org ([80.91.229.2]:39441 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXJ1SwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:52:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check dependencies for modules "dm-snapshot" and "sd_mod" in
 kernel 2.6.23.1
Date: Sun, 28 Oct 2007 19:51:37 +0100
Message-ID: <4724DA39.4020601@web.de>
References: <fg2b7g$1hj$1@ger.gmane.org> <Pine.LNX.4.64.0710281700360.30465@fbirervta.pbzchgretzou.qr> <fg2fhb$tev$1@ger.gmane.org> <Pine.LNX.4.64.0710281815020.30465@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c416a.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <Pine.LNX.4.64.0710281815020.30465@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you really have to roll your own kernel (often this is not the case-YMMV),
> I suggest you enable dm-snapshot and sd_mod.

I intentionally omitted the configuration option "DM_SNAPSHOT" because it is marked as
"EXPERIMENTAL".
Snapshot target:
"Allow volume managers to take writable snapshots of a device."

I intentionally checked the option "BLK_DEV_SD". I do not want to build it as a module.
SCSI disk support:
"If you want to use SCSI hard disks, Fibre Channel disks,
Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
USB storage or the SCSI or parallel port version of
the IOMEGA ZIP drive, say Y and read the SCSI-HOWTO,
the Disk-HOWTO and the Multi-Disk-HOWTO, available from
<http://www.tldp.org/docs.html#howto>. This is NOT for SCSI
CD-ROMs.

To compile this driver as a module, choose M here and read
<file:Documentation/scsi/scsi.txt>.
The module will be called sd_mod.

Do not compile this driver as a module if your root file system
(the one containing the directory /) is located on a SCSI disk.
In this case, do not compile the driver for your SCSI host adapter
(below) as a module either."


Do I expect more from the dependency management than it is provided at the moment?

Regards,
Markus

