Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXGNH1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXGNH1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXGNH1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:27:23 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:10503 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXGNH1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tX9Ll/VPNKstkT9G54qwpZr8pp7GHvyL9twniAQ5CE5wmksi1c5xA6PtOjWe02bo9vG7E57KMl8Q9fGgEILtOhYujctG0mBLW+lqU19HkY6iZH7LOCSFEUIqSQiKo8twhYGlJeZz7NnzkNp4UcURnC/EvLzBBIMYRT52lrIXrm4=
Message-ID: <b8c19edb0707140027y6f525dbew52b60128012007b2@mail.gmail.com>
Date: Sat, 14 Jul 2007 12:57:22 +0530
From: Surya <surya.prabhakar@gmail.com>
To: caglar@pardus.org.tr, kkeil@suse.de, linux-kernel@vger.kernel.org
Subject: RE:[PATCH 0/12] drivers/isdn: replace pci_find_device with pci_get_device
Cc: surya.prabhakar@wipro.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...
   Recently Keil has accepted few isdn related , pci_find_device
cleanup patches, which are currently in -mm tree and would probably be
in mainline kernel soon..

look the below url shows a mail from karsten keil..
http://marc.info/?l=linux-kernel&m=118029832418653&w=2
Just make sure patch only the files not listed in the above patch..
Also look at the kernel archives before you start patching , just to
make sure somebody has not done it already..


thanks
surya.








List:       linux-kernel
Subject:    [PATCH 0/12] drivers/isdn: replace pci_find_device with
pci_get_device
From:       "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar () pardus
! org ! tr>
Date:       2007-07-13 22:44:12
Message-ID: 200707140144.14644.caglar () pardus ! org ! tr
[Download message RAW]

Hi;

Following patches replaces pci_find_device with pci_get_device (with some
whitespace cleanups) to avoid following warnings;

warning: `pci_find_device' is deprecated (declared at include/linux/pci.h:478)

occured while compiling the kernel for ages.

Although ISDN subsystem marked as Maintained, last activity on ISDN
subsystem's git tree occured 21 Month ago :( so for this reason i'm adding
LKML also.

[1] http://git.kernel.org/?p=linux/kernel/git/kkeil/isdn-2.6.git;a=summary

Cheers
