Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbXB0RZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbXB0RZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXB0RZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:25:14 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:54230 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXB0RZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:25:13 -0500
Message-ID: <45E46976.6060600@freescale.com>
Date: Tue, 27 Feb 2007 11:25:10 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: lanana: Add major/minor entries for PPC QE UART devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Email to device@lanana.org bounces, so I'm sending this to lkml instead.)

I'm working on a UART device driver for the Freescale PowerPC QUICCEngine, which
is a replacement for the CPM.  Since the QE is basically "CPM v3", and you can't
have a CPM and a QE on the same board, I figure that they can share the same
minor numbers.

I've attached a patch that adds these entries to major number 204.  Please not
that there's a small typo for /dev/ttyCPM5, and I've fixed that in the patch as
well.

Please let me know if my proposal/patch is acceptable, and if not, what changes
you want me to make.  Thanks.

patch:

Fixed a typo with /dev/ttyCPM5.  Added entries for /dev/ttyQE0-3.  The QE
is a replacement for the CPM, so they can share the same minor numbers.

--- devices-2.6+.txt	2007-02-22 13:37:18.000000000 -0600
+++ devices-2.6+.new	2007-02-22 13:42:50.000000000 -0600
@@ -2770,7 +2770,10 @@
  		 45 = /dev/ttyMM1		Marvell MPSC - port 1
  		 46 = /dev/ttyCPM0		PPC CPM (SCC or SMC) - port 0
  		    ...
-		 47 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 5
+		 49 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 5
+		 46 = /dev/ttyQE0		PPC QE (UCC) - port 0
+		    ...
+		 49 = /dev/ttyQE3		PPC QE (UCC) - port 3
  		 50 = /dev/ttyIOC0		Altix serial card
  		    ...
  		 81 = /dev/ttyIOC31		Altix serial card


-- 
Timur Tabi
Linux Kernel Developer @ Freescale

