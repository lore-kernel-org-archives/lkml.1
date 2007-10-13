Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbXJMHQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbXJMHQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXJMHQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:16:16 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:36482 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbXJMHQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:16:15 -0400
Message-ID: <471070A3.6020003@linux.vnet.ibm.com>
Date: Sat, 13 Oct 2007 12:45:47 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.23-git2 buid failure
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 2.6.23-git2 build fails with build error 

  CC [M]  drivers/mmc/core/core.o
  CC [M]  drivers/mmc/core/sysfs.o
  CC [M]  drivers/mmc/core/bus.o
  CC [M]  drivers/mmc/core/host.o
drivers/mmc/core/host.c: In function ‘mmc_remove_host’:
drivers/mmc/core/host.c:146: error: implicit declaration of function ‘led_trigger_unregister’
drivers/mmc/core/host.c:146: error: ‘struct mmc_host’ has no member named ‘led’
make[3]: *** [drivers/mmc/core/host.o] Error 1
make[2]: *** [drivers/mmc/core] Error 2
make[1]: *** [drivers/mmc] Error 2
make: *** [drivers] Error 2

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
