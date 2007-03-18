Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbXCRS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbXCRS56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXCRS56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:57:58 -0400
Received: from dxa01.wellsfargo.com ([151.151.65.117]:57359 "EHLO
	dxa01.wellsfargo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627AbXCRS55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:57:57 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Mar 2007 14:57:57 EDT
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: 1000xf bus problem
Date: Sun, 18 Mar 2007 13:51:08 -0500
Message-ID: <E8C008223DD5F64485DFBDF6D4B7F71D0289EDB4@msgswbmnmsp25.wellsfargo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 1000xf bus problem
Thread-Index: AcdpjmNe9fp9JYNFQY2Rp1epCP8JUw==
From: <Greg.Chandler@wellsfargo.com>
To: <e1000-devel@lists.sourceforge.net>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Mar 2007 18:51:11.0578 (UTC) FILETIME=[65B1EBA0:01C7698E]
X-WFMX: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm running a e1000xf adapter in a 64-bit/100Mhz PCI slot.  The intel
site shows this is a supported config for the card, but linux is pulling
this info:

ed:02.0 Ethernet controller: Intel Corporation 82544EI Gigabit Ethernet
Controller (Fiber) (rev 02)
	Subsystem: Intel Corporation PRO/1000 XF Server Adapter
	Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 18
	Memory at f7fe0000 (64-bit, non-prefetchable) [size=128K]
      Memory at f7fc0000 (64-bit, non-prefetchable) [size=128K]
      I/O ports at 7000 [size=32]
      [virtual] Expansion ROM at f10a0000 [disabled] [size=128K]
      Capabilities: [dc] Power Management version 2
      Capabilities: [e4] PCI-X non-bridge device
      Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable-

My thoughput tests show it is definitely not running at the 100Mhz bus
rate is should be capable of.
Any ideas on how to make it work at full speed?
