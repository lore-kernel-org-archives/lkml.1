Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbXKMOpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbXKMOpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXKMOpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:45:00 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:51772 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbXKMOo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:44:59 -0500
Message-ID: <4739B81A.3050601@linux.vnet.ibm.com>
Date: Tue, 13 Nov 2007 20:13:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, benh@kernel.crashing.org,
       linux-arch@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-13-04-14 Build Fails at memory.c
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
In-Reply-To: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, with following build error

mm/memory.c: In function ‘free_pte_range’:
mm/memory.c:126: error: implicit declaration of function ‘pmd_pgtable’
mm/memory.c:126: warning: initialization makes pointer from integer without a cast
mm/memory.c: In function ‘apply_to_pte_range’:
mm/memory.c:1389: warning: assignment makes pointer from integer without a cast
make[1]: *** [mm/memory.o] Error 1
make: *** [mm] Error 2

The patch causing this issue is config_highpte-vs-sub-page-page-tables.patch.
Where the marco is defined #ifndef CONFIG_PPC_64K_PAGES.
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
