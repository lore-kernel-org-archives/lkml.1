Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbXIFTLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbXIFTLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 15:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbXIFTKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 15:10:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56099 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbXIFTKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 15:10:54 -0400
Date: Thu, 6 Sep 2007 21:10:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: linux-scsi@vger.kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sym53c8xx rescan
Message-ID: <Pine.LNX.4.64.0709062105060.25942@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,


issuing `echo "- - -" >/sys/class/scsi_host/host0/scan` where host0 is a 

0001:00:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 
(rev 14)
sym0: <875> rev 0x14 at pci 0001:00:03.0 irq 13

does not produce any dmesg messages (2.6.21), so I suspect it did not 
rescan the bus; though, the echo command _did_ take a while (as does the 
boot procedure), so it may have done _something_ and does not let me 
know. How could I verify this, or does sym53c8xx.ko does not support 
rescanning?



	Jan
-- 
