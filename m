Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXFYWes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXFYWes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXFYWem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:34:42 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:27136 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbXFYWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:34:41 -0400
X-SBRS: None
X-RemoteIP: 81.1.72.27
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=agXSIi-85AFr49-lKeQA:9 a=m6AtMy-tm06i8EeZ14d9Nafo83gA:4
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALfff0ZRAUgb/2dsb2JhbACBSQ
X-IronPort-AV: E=Sophos;i="4.16,460,1175468400"; 
   d="scan'208";a="4055003"
Subject: 2.6.22-rc6 on Dreamcast (SH4)
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linux-sh <linuxsh-dev@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 23:34:22 +0100
Message-Id: <1182810862.6017.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still getting this:

 MODPOST vmlinux
WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
mismatch: reference to .init.text: (between 'mv_dreamcast' and
'systemasic_int')
WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch: reference
to .init.data: (between 'pvr2fb_check_var' and 'pvr2fb_interrupt')
WARNING: drivers/built-in.o(.text+0x1701c): Section mismatch: reference
to .init.data: (between 'pvr2fb_pci_probe' and 'read_mem')
WARNING: drivers/built-in.o(.text+0x17024): Section mismatch: reference
to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
WARNING: drivers/built-in.o(.data+0x738): Section mismatch: reference
to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
WARNING: drivers/built-in.o(.data+0x750): Section mismatch: reference
to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')

But compiles and executes
