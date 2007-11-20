Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbXKTLaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbXKTLaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 06:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbXKTLa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 06:30:27 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52646 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752439AbXKTLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 06:30:26 -0500
Message-ID: <4742C54B.1080709@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2007 17:00:19 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails on AMD Opteron

  CC      arch/x86/kernel/setup_64.o
arch/x86/kernel/setup_64.c: In function ‘early_identify_cpu’:
arch/x86/kernel/setup_64.c:904: warning: unused variable ‘xlvl’
arch/x86/kernel/setup_64.c: In function ‘identify_cpu’:
arch/x86/kernel/setup_64.c:960: error: ‘xlvl’ undeclared (first use in this function)
arch/x86/kernel/setup_64.c:960: error: (Each undeclared identifier is reported only once
arch/x86/kernel/setup_64.c:960: error: for each function it appears in.)
arch/x86/kernel/setup_64.c: At top level:
arch/x86/kernel/setup_64.c:991: error: redefinition of ‘identify_cpu’
arch/x86/kernel/setup_64.c:958: error: previous definition of ‘identify_cpu’ was here
make[1]: *** [arch/x86/kernel/setup_64.o] Error 1
make: *** [arch/x86/kernel] Error 2

The patch causing this error is git-x86.patch

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
