Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbXLDKYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbXLDKYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXLDKXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:23:53 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51043 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752088AbXLDKXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:23:52 -0500
Message-ID: <47552A98.9010108@linux.vnet.ibm.com>
Date: Tue, 04 Dec 2007 15:53:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ptiedem@de.ibm.com, braunu@de.ibm.com, jeff@garzik.org,
       linux-s390@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [build failure] Re: Linux 2.6.24-rc4 on S390x
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch ctc: make use of alloc_netdev() (commit 1c1478859017452a1179dbbdf7b9eb5b48438746)
introduces the build failure

  CC [M]  drivers/s390/net/fsm.o
  CC [M]  drivers/s390/net/smsgiucv.o
  CC [M]  drivers/s390/net/ctcmain.o
drivers/s390/net/ctcmain.c: In function `ctc_init_netdevice':
drivers/s390/net/ctcmain.c:2805: error: implicit declaration of function `SET_MODULE_OWNER'
make[2]: *** [drivers/s390/net/ctcmain.o] Error 1
make[1]: *** [drivers/s390/net] Error 2
make: *** [drivers/s390] Error 2

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
