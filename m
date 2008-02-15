Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbYBOJUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbYBOJUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYBOJUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:20:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:26052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYBOJUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:20:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,357,1199692800"; 
   d="scan'208";a="258048346"
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080215084827.GB25949@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org>
	 <20080214161218.GA28152@elte.hu>
	 <1203050886.30010.19.camel@caritas-dev.intel.com>
	 <20080215084827.GB25949@one.firstfloor.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 17:21:02 +0800
Message-Id: <1203067262.30010.34.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 15 Feb 2008 09:20:00.0422 (UTC) FILETIME=[F0770460:01C86FB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 09:48 +0100, Andi Kleen wrote:
> On Fri, Feb 15, 2008 at 12:48:06PM +0800, Huang, Ying wrote:
> > 
> > This patch has been tested on Intel x86 platform with EFI 32/64.
> 
> Can EFI_PAGE_SIZE ever be < 4k? If yes you would need to round up
> first to linux page size before shifting.

Yes. It is needed. And md->virt_addr should be processed as follow:

md->virt_addr & PAGE_MASK

before fed into set_memory_*.

Best Regards,
Huang Ying

