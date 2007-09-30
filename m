Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXI3Ji0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXI3Ji0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 05:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXI3JiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 05:38:19 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58056 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXI3JiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 05:38:18 -0400
Message-ID: <46FF6E6A.30808@linux.vnet.ibm.com>
Date: Sun, 30 Sep 2007 15:07:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org, paulus@samba.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm2 - PowerPC link failure at arch/powerpc/kernel/head_64.o
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <46FF2199.2060202@linux.vnet.ibm.com>
In-Reply-To: <46FF2199.2060202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The compilation with the cross compiler for the PowerPC-405 on the powerbox
> fails at linking
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> ld: arch/powerpc/kernel/head_64.o(.text+0x80c8): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
> ld: arch/powerpc/kernel/head_64.o(.text+0x8160): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
> ld: arch/powerpc/kernel/head_64.o(.text+0x81c4): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
> ld: final link failed: Bad value
> make: *** [.tmp_vmlinux1] Error 1
> 

Adding CC to the powerpc mailing list

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
