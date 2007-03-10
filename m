Return-Path: <linux-kernel-owner+w=401wt.eu-S1767836AbXCJPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767836AbXCJPAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767839AbXCJPAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:00:37 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:19742 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767836AbXCJPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:00:36 -0500
From: Grozdan Nikolov <microchip@chello.be>
To: linux-kernel@vger.kernel.org
Subject: imm module issues
Date: Sat, 10 Mar 2007 16:00:28 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101600.28449.microchip@chello.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've compiled the 2.6.20.2 kernel today (I took the SuSE HEAD kernel instead 
of the vanilla one) and I'm having issues with the "imm" module. I still use 
a ZIP drive here for small backups and the "imm" module worked flawless on 
kernel 2.6.18.8 but with kernel 2.6.20.2 I get error messages that the device 
is offline even if the device is switched on and has a ZIP disk inside of it.

This is what I get from "dmesg" (Sorry for posting this here if it's the wrong 
place, but I wasn't sure if I should report this to Novell's bugzilla because 
I'm using the SuSE head kernel which is not officially supported)

imm: Version 2.05 (for Linux 2.4.0)
imm: Found device at ID 6, Attempting to use EPP 32 bit
imm: Communication established at 0x378 with ID 6 using EPP 32 bit
scsi1 : Iomega VPI2 (imm) interface
scsi 1:0:6:0: Direct-Access     IOMEGA   ZIP 250          L.58 PQ: 0 ANSI: 2
sd 1:0:6:0: scsi: Device offlined - not ready after error recovery
sd 1:0:6:0: rejecting I/O to offline device
sd 1:0:6:0: rejecting I/O to offline device
sd 1:0:6:0: rejecting I/O to offline device
sd 1:0:6:0: rejecting I/O to offline device
sda : READ CAPACITY failed.
sda : status=0, message=00, host=1, driver=00
sda : sense not available.
sd 1:0:6:0: rejecting I/O to offline device
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sd 1:0:6:0: rejecting I/O to offline device
sda: asking for cache data failed
sda: assuming drive cache: write through
sd 1:0:6:0: Attached scsi removable disk sda
sd 1:0:6:0: Attached scsi generic sg0 type 0
-- 
go openSUSE go!
