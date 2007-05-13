Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbXEMLEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbXEMLEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 07:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbXEMLEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 07:04:44 -0400
Received: from userg504.nifty.com ([202.248.238.84]:45427 "EHLO
	userg504.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbXEMLEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 07:04:43 -0400
DomainKey-Signature: a=rsa-sha1; s=userg504; d=nifty.com; c=nofws; q=dns;
	b=J4s7beAbLwABZ6ZvFCF0FaG5Cs3dtmgIiTZC/9mcGE9cr3j4NnB11jZd5SxjVlQXy
	fYv2YdFaiaRzjWe21D4Dg==
Date: Sun, 13 May 2007 20:04:44 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Subject: [SMP BUG] kernel 2.6.21:  irqbalance does not work properly
Message-Id: <20070513200444.9d2db4c3.komurojun-mbn@nifty.com>
In-Reply-To: <20070510160615.6aa9cef6.akpm@linux-foundation.org>
References: <1178202559.3767.21.camel@localhost.localdomain>
	<20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
	<1178463619.3793.14.camel@localhost.localdomain>
	<1178777214.2951.18.camel@ymzhang>
	<20070510160615.6aa9cef6.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The irqbalance does not work properly with kernel 2.6.21
on DualCore processor(AMD Athlon64 X2)

(The irq is not distributed to two Core
 ,most of the irq is distributed to CPU1)

Kernel 2.6.20 does not have this problem.

The irqbalance version is 1.13-4.fc6.

Any idea to fix this problem?

           CPU0       CPU1       
  0:         85          0   IO-APIC-edge      timer
  1:          0        698   IO-APIC-edge      i8042
  6:          0          5   IO-APIC-edge      floppy
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0        114   IO-APIC-edge      i8042
 14:        369       2281   IO-APIC-edge      ide0
 15:          0         24   IO-APIC-edge      ide1
 16:         15      38239   IO-APIC-fasteoi   yenta, pcnet_cs
 17:          0          0   IO-APIC-fasteoi   yenta
NMI:          0          0 
LOC:      50548      50547 
ERR:          0
MIS:      15503


Best Regards
Komuro
