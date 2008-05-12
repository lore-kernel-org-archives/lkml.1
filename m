Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbYELLZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbYELLZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYELLZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:25:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53481
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYELLY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:24:59 -0400
Date: Mon, 12 May 2008 04:24:53 -0700 (PDT)
Message-Id: <20080512.042453.238263459.davem@davemloft.net>
To: jlieskov@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc: Fix mremap VA span checking.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210590913.10883.9.camel@dhcp-lab-164.englab.brq.redhat.com>
References: <1210590913.10883.9.camel@dhcp-lab-164.englab.brq.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Lieskovsky <jlieskov@redhat.com>
Date: Mon, 12 May 2008 13:15:12 +0200

>  I have investigated the code for MREMAP_FIXED in
> sparc_mremap in arch/sparc/kernel/sys_sparc.c, for sys64_mremap
> in arch/sparc64/kernel/sys_sparc.c and 
> for sys32_mremap in arch/sparc64/kernel/sys_sparc32.c
> and there are similar conditional range checks ->
> attaching the patches against 2.6.25.3.

Thanks for the report, I'll take a look at this after getting
some sleep as it's late hear.

My first impression is that it might make sense to put an
arch_mmap_check() call at the appropriate spots instead of duplicating
this check so many times.
