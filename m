Return-Path: <linux-kernel-owner+w=401wt.eu-S938952AbXFHV3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938952AbXFHV3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXFHV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:29:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:42565 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbXFHV3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="237187990"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Fri, 8 Jun 2007 14:28:56 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <20070608141500.0af58fac.akpm@linux-foundation.org>
In-Reply-To: <20070608141500.0af58fac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081428.56596.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 8, 2007 2:15:00 Andrew Morton wrote:
> > Something similar could be done on i386 if needed, but the boot
> > ordering would be slightly different, since the MTRR code on i386
> > depends on the boot_cpu_data structure being setup.
>
> i386 allmodconfig:
>
> arch/i386/kernel/cpu/mtrr/main.c: In function
> 'mtrr_trim_uncached_memory': arch/i386/kernel/cpu/mtrr/main.c:655:
> error: 'end_pfn' undeclared (first use in this function)
> arch/i386/kernel/cpu/mtrr/main.c:655: error: (Each undeclared
> identifier is reported only once
> arch/i386/kernel/cpu/mtrr/main.c:655: error: for each function it
> appears in.)
>
> I'll poke some ifdefs in there.

Oops, sorry about that, the code is only called on x86_64 but compiled 
even for i386...

Jesse
