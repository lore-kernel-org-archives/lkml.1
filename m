Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbXKTNHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbXKTNHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXKTNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:07:32 -0500
Received: from www.tglx.de ([62.245.132.106]:40981 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbXKTNHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:07:31 -0500
Date: Tue, 20 Nov 2007 14:07:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
In-Reply-To: <4742C54B.1080709@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.0.9999.0711201405480.25057@localhost.localdomain>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <4742C54B.1080709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2104343075-1195564022=:25057"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2104343075-1195564022=:25057
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Tue, 20 Nov 2007, Kamalesh Babulal wrote:

> Hi Andrew,
> 
> The kernel build fails on AMD Opteron
> 
>   CC      arch/x86/kernel/setup_64.o
> arch/x86/kernel/setup_64.c: In function ‘early_identify_cpu’:
> arch/x86/kernel/setup_64.c:904: warning: unused variable ‘xlvl’
> arch/x86/kernel/setup_64.c: In function ‘identify_cpu’:
> arch/x86/kernel/setup_64.c:960: error: ‘xlvl’ undeclared (first use in this function)
> arch/x86/kernel/setup_64.c:960: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/setup_64.c:960: error: for each function it appears in.)
> arch/x86/kernel/setup_64.c: At top level:
> arch/x86/kernel/setup_64.c:991: error: redefinition of ‘identify_cpu’
> arch/x86/kernel/setup_64.c:958: error: previous definition of ‘identify_cpu’ was here
> make[1]: *** [arch/x86/kernel/setup_64.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> The patch causing this error is git-x86.patch

Jeremy pointed me to this already. I'm looking into this.

Thanks,

	tglx
--8323328-2104343075-1195564022=:25057--
