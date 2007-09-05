Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXIEPd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXIEPd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXIEPdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:33:22 -0400
Received: from edunivtw01.ad.umassmed.edu ([146.189.195.116]:3663 "EHLO
	nlb-securemail.umassmed.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756550AbXIEPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:33:21 -0400
X-Greylist: delayed 3625 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 11:33:20 EDT
X-Server-Uuid: D1A27D3C-4100-4955-B400-0F8801E7DACA
Message-ID: <46DEBE06.5010401@umassmed.edu>
Date: Wed, 05 Sep 2007 10:32:38 -0400
From: "Karl Bellve" <Karl.Bellve@umassmed.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PCI: Unable to reserve mem region problem
X-OriginalArrivalTime: 05 Sep 2007 14:32:38.0934 (UTC)
 FILETIME=[9C138B60:01C7EFC9]
X-WSS-ID: 6AC0619B24810959765-02-01
Content-Type: multipart/mixed;
 boundary=------------040804070901090606060202
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040804070901090606060202
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit


Please CC any response. Thanks.

I am having an issue with a Supermicro h8dce motherboard and failure to 
recognize a 5th SATA drive after upgrading to Fedora 7.

This motherboard has 8 sata ports that use the sata_nv driver.

The lack of seeing the 5th SATA drive shows up in 2.6.22 kernels, such 
as kernel-2.6.22.2-42.fc6 and kernel-2.6.22.1-41.fc7.

The 5th SATA drive can still be detected in 2.6.20 kernels such as 
kernel-2.6.20-1.2933.fc6 (I am currently using this kernel).

 From dmesg, it appears the reason I am not seeing the 5th SATA drive 
(second SATA controller) is the following error:

Aug 30 14:08:03 alcor kernel: sata_nv 0000:80:08.0: Using ADMA mode
Aug 30 14:08:03 alcor kernel: PCI: *Unable to reserve mem region* 
#6:1000@dfefd000 for device 0000:80:08.0
Aug 30 14:08:03 alcor kernel: ACPI: PCI interrupt for device 
0000:80:08.0 disabled
Aug 30 14:08:03 alcor kernel: sata_nv: probe of 0000:80:08.0 failed with 
error -16

sata_nv that comes with the 2.6.22 kernels appear to be version 3.4 
while the older kernels comes with version 3.2 (which work). I contacted 
Robert Hancock directly about this and he suggested I post an email to LKML.

Motherboard: 
http://www.supermicro.com/Aplus/motherboard/Opteron/nForce/H8DCE.cfm
Single AMD Opteron(tm) Processor 244
1 GB of memory.

I can send you the complete dmesg output if you would like.

Thanks!




--------------040804070901090606060202
Content-Type: text/plain;
 charset=utf-8;
 name=Karl.Bellve.vcf
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=Karl.Bellve.vcf

begin:vcard
fn:Karl Bellve
n:Bellve;Karl
org:Biomedical Imaging Group;Department of Physiology
adr:2 Biotech, Suite 114;;373 Plantation Street;Worcester;Massachusetts;01655;United States of America
email;internet:Karl.Bellve@umassmed.edu
title:Assistant Professor
tel;work:508-856-6514
tel;fax:508-856-6514
x-mozilla-html:TRUE
version:2.1
end:vcard


--------------040804070901090606060202--

