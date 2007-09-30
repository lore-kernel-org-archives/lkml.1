Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXI3EKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXI3EKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 00:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXI3EKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 00:10:36 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41385 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbXI3EKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 00:10:36 -0400
Message-ID: <46FF2199.2060202@linux.vnet.ibm.com>
Date: Sun, 30 Sep 2007 09:40:01 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm2 - PowerPC link failure at arch/powerpc/kernel/head_64.o
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
In-Reply-To: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The compilation with the cross compiler for the PowerPC-405 on the powerbox
fails at linking

  LD      init/built-in.o
  LD      .tmp_vmlinux1
ld: arch/powerpc/kernel/head_64.o(.text+0x80c8): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
ld: arch/powerpc/kernel/head_64.o(.text+0x8160): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
ld: arch/powerpc/kernel/head_64.o(.text+0x81c4): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
ld: final link failed: Bad value
make: *** [.tmp_vmlinux1] Error 1

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
