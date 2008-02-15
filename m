Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbYBOJXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbYBOJXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYBOJWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:22:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:41266 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbYBOJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:22:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,357,1199692800"; 
   d="scan'208";a="379396263"
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080215085501.GC25949@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org>
	 <20080214161218.GA28152@elte.hu>
	 <20080214171603.GC16255@one.firstfloor.org>
	 <20080214183819.GA19846@elte.hu>
	 <1203043953.30010.14.camel@caritas-dev.intel.com>
	 <20080215085501.GC25949@one.firstfloor.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 17:16:53 +0800
Message-Id: <1203067013.30010.31.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 15 Feb 2008 09:15:50.0851 (UTC) FILETIME=[5BB58130:01C86FB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 09:55 +0100, Andi Kleen wrote:
> > But because end_pfn_map contains the above UC memory area, efi_ioremap()
> > is not used on EFI 64.
> 
> I see. It would be a good idea if you could test with a limited
> memmap (mem=... command line option) just to make sure this path works

I tested efi_ioremap with "memmap=...", and it works fine on my 2G EFI
box.

Best Regards,
Huang Ying

