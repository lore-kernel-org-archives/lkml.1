Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbXFDRXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbXFDRXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbXFDRXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:23:03 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:48111 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbXFDRXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:23:01 -0400
Message-ID: <46644A71.7060300@dgreaves.com>
Date: Mon, 04 Jun 2007 18:22:57 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
References: <46609290.5030701@dgreaves.com> <46613C53.8010205@gmail.com> <4661E6CA.1080203@dgreaves.com> <46643DE5.3080904@rtr.ca>
In-Reply-To: <46643DE5.3080904@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> David Greaves wrote:
>> I have 2 ide disks. If I enable SMART and hibernate/suspend2disk,
>> SMART is
>> disabled when I resume.
> 
> Just a thought:  This *may* be fixable at the drive, with "hdparm -K1".

Thanks Mark, good idea.
Just tried and it didn't help though :(

in fact, hda gave
cu:~# hdparm -K1 /dev/hda

/dev/hda:
 setting drive keep features to 1 (on)
 HDIO_DRIVE_CMD(keepsettings) failed: Input/output error

and in dmesg:
hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hda: drive_cmd: error=0x04 { DriveStatusError }
ide: failed opcode was: 0xef

The drive, FWIW, is:
=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda ATA II family
Device Model:     ST320420A
Serial Number:    3CL04RKY
Firmware Version: 3.21
User Capacity:    20,404,101,120 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   4
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Jun  4 18:20:46 2007 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


David
