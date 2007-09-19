Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXISMYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXISMYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXISMY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:24:26 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45228 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbXISMY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:24:26 -0400
Message-ID: <46F114D2.40809@linux.vnet.ibm.com>
Date: Wed, 19 Sep 2007 17:53:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       amitkale@linsyssoft.com, trini@kernel.crashing.org
Subject: 2.6.23-rc6-mm1 powerpc - kgdb is broken
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kgdb seems to be broken on the powerpc, while compiling with
allyesconfig.

  LD [M]  drivers/isdn/hysdn/hysdn.o
  CC [M]  drivers/net/kgdboe.o
  CC [M]  drivers/scsi/scsi_wait_scan.o
In file included from include/linux/kgdb.h:22,
                 from drivers/net/kgdboe.c:28:
include/asm/kgdb.h:34: error: 'debugger' redeclared as different kind of symbol
include/asm/system.h:85: error: previous definition of 'debugger' was here
include/asm/kgdb.h:35: error: 'debugger_bpt' redeclared as different kind of symbol
include/asm/system.h:87: error: previous definition of 'debugger_bpt' was here
include/asm/kgdb.h:36: error: 'debugger_sstep' redeclared as different kind of symbol
include/asm/system.h:88: error: previous definition of 'debugger_sstep' was here
include/asm/kgdb.h:37: error: 'debugger_iabr_match' redeclared as different kind of symbol
include/asm/system.h:89: error: previous definition of 'debugger_iabr_match' was here
include/asm/kgdb.h:38: error: 'debugger_dabr_match' redeclared as different kind of symbol
include/asm/system.h:90: error: previous definition of 'debugger_dabr_match' was here
include/asm/kgdb.h:39: error: 'debugger_fault_handler' redeclared as different kind of symbol
include/asm/system.h:91: error: previous definition of 'debugger_fault_handler' was here
In file included from drivers/net/kgdboe.c:28:
include/linux/kgdb.h:69: error: 'BREAK_INSTR_SIZE' undeclared here (not in a function)
make[3]: *** [drivers/net/kgdboe.o] Error 1
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [modules] Error 2

-- 

Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

