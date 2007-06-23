Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXFWLQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXFWLQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXFWLPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:15:46 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:53354 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbXFWLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:15:44 -0400
X-SBRS: None
X-RemoteIP: 81.1.80.59
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=agXSIi-85AFr49-lKeQA:9 a=RZ18xSD4QsOe-XxQizRy8XzzrZgA:4
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJSdfEZRAVA7/2dsb2JhbACBSg
X-IronPort-AV: E=Sophos;i="4.16,454,1175468400"; 
   d="scan'208";a="3543392"
Subject: Problems with -rc5 afterall on Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linux-sh <linuxsh-dev@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 12:15:25 +0100
Message-Id: <1182597325.6001.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Previously it had compiled and built cleanly, but when I added in the
sound driver I got this:

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
