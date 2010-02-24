Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0BXVK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:10:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:10477 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab0BXVKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:10:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,534,1262592000"; 
   d="scan'208";a="598887175"
Subject: Re: Panic in reserve_memtype()
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Jack Steiner <steiner@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100224202258.GA615@sgi.com>
References: <20100224202258.GA615@sgi.com>
Content-Type: text/plain
Date: Wed, 24 Feb 2010 13:09:24 -0800
Message-Id: <1267045764.16916.920.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2010-02-24 at 12:22 -0800, Jack Steiner wrote:
> We see an X86_64 regression that started a few days ago. The kernel is booted
> via EFI & panics in the pat.c code trying to deref a NULL pointer.
> 
> I didn't debug the problem but am suspicious of
> 	x86, pat: Migrate to rbtree only backend for pat memtype management  x86/pat
> 		author	Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>	
> 		Wed, 10 Feb 2010 23:26:07 +0000 (15:26 -0800)
> 	committer	H. Peter Anvin <hpa@zytor.com>	
> 		Thu, 18 Feb 2010 23:41:36 +0000 (15:41 -0800)
> 
> 
> 
> Has anyone seen this? If not, I can debug further....
> 


Haven't seen this on my test systems here, but I haven't tested with EFI
boot either.

I assume this is repeatable, and you always see this panic. I am looking
at the code right now. Can you rollback this particular patch and see
whether it goes away?

Thanks,
Venki

