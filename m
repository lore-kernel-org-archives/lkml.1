Return-Path: <linux-kernel-owner+w=401wt.eu-S932365AbZAGWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbZAGWsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbZAGWsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:48:18 -0500
Received: from mail91.analogic.com ([12.187.86.31]:48776 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757521AbZAGWsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:48:15 -0500
X-Greylist: delayed 1485 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 17:48:15 EST
X-AuditID: 0a770115-ac9eebb000000e72-18-49652b628fbd
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MIMEOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 07 Jan 2009 22:23:09.0153 (UTC) FILETIME=[85029D10:01C97116]
Content-class: urn:content-classes:message
Subject: Inconsistent disk state when creating paritions
Date: Wed, 7 Jan 2009 17:23:09 -0500
Message-ID: <Pine.LNX.4.61.0901071715070.9551@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: Inconsistent disk state when creating paritions
thread-index: AclxFoUJ5Hrrt45OSXGOvmyxN9wc3w==
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting to use mkfs immediately after creating
partitions using sfdisk, (in the same shell-script)
fails with all kernels I have tried. The partition
information doesn't get updated for several seconds!

In every case, with both ext2 and ext3 file-systems,
I can create them manually or I can sleep in the
shell-script. However, I don't think this problem
should exist.

The problem was first discovered with old-fashioned
IDE disks. I don't have any spare SATA drives to
see if the problem exists there. I note that sfdisk
says it is re-reading to update the parition information.


Does anybody know about this or care?


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4784.32 Gimps).
My book : http://www.AbominableFirebug.com/
.


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
