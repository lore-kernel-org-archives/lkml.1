Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZGVTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZGVTpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZGVTpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:45:52 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:46000 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZGVTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:45:51 -0400
Subject: Boot Hang - mmotm 090716 - serial 8250 irq flags support
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vikram Pandita <vikram.pandita@ti.com>, Alan Cox <alan@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Eric Whitney <eric.whitney@hp.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 22 Jul 2009 15:45:48 -0400
Message-Id: <1248291948.4490.67.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmotm dated 17jul09 atop 2.6.31-rc3 hangs [or appears to--could have
just lost remote access via virtual serial port] during boot on HP
Proliant DL585 [and perhaps others].  Checking back, the last mmotm to
boot successfully on this platform was the 25jun09 snapshot.

The offending patch appears to be commit
0b8d7a6fbba81ffd06de701fa6178916ee9732c3 - "serial-add-irqflags-support"
in the linux-next mega-patch.  Reverting the changes to the 8250 driver
allows the kernel to boot and operate normally.

Regards,
Lee





