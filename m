Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYIDSlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYIDSlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYIDSiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:38:54 -0400
Received: from ns2.bglans.net ([217.79.67.244]:35806 "EHLO mail.bglans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116AbYIDSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:38:52 -0400
Date: Thu, 4 Sep 2008 21:07:49 +0300 (EEST)
From: ivaylo@bglans.net
To: linux-kernel@vger.kernel.org
cc: w@1wt.eu
Subject: ICH9 AHCI support on 2.4.XX
In-Reply-To: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
Message-ID: <Pine.LNX.4.64.0809042051030.10716@mail.bglans.net>
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1339683907-1130448773-1220551669=:10716"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1339683907-1130448773-1220551669=:10716
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


Hello,

I Have Intel motherboard model DG33BU. It is with G33 chipset. There 
is, Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller,
on it. So I make small patch to support this controler in kernel (see 
bellow or the attached file). Probably it will work and on the 
other mobos with same chipset.


diff -ru a/drivers/scsi/ahci.c b/drivers/scsi/ahci.c
--- a/drivers/scsi/ahci.c       2008-01-01 14:06:40.000000000 +0200
+++ b/drivers/scsi/ahci.c       2008-05-02 01:35:49.000000000 +0300
@@ -285,6 +285,8 @@
           board_ahci }, /* ICH8M */
         { PCI_VENDOR_ID_INTEL, 0x282a, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
           board_ahci }, /* ICH8M */
+       { PCI_VENDOR_ID_INTEL, 0x2922, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+         board_ahci }, /* ICH9 */
         { 0x197b, 0x2360, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
           board_ahci }, /* JMicron JMB360 */
         { 0x197b, 0x2363, PCI_ANY_ID, PCI_ANY_ID, 0, 0,




Best Regards,
Ivaylo Josifov

--1339683907-1130448773-1220551669=:10716
Content-Type: APPLICATION/octet-stream; name=ICH9.patch.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0809042107490.10716@mail.bglans.net>
Content-Description: 
Content-Disposition: attachment; filename=ICH9.patch.gz

H4sICC4UwEgAA0lDSDkucGF0Y2gAnc5da8IwFAbga/sr3mvTmNP0w7RX3VSw
Y3ZDRPCq9ENZbiakbAjifzeVeSF0KywcOCFvzsNp9OEAbr5Qisbo771pRVu3
WpQftZ7UqPpeHc55//+RJFKcPFvwgoSiJKAJ3Q8Y2dxhjPW7P9MhJwnyEj9M
gvhh2rfTaQouVehGYF1TSFMHI6A6lqYpOggXF2KMbLZUK4yFTc94n2XFdpHP
39ZFNi+yfLN4dUEnqWTp3sKnfGeTxzt1NYCzP/BYyiGc/YLH98Xp5MXT6sb5
Ef1r15eVrs3x0/ZnS/TC/hB8BY82XaQnAgAA

--1339683907-1130448773-1220551669=:10716--
