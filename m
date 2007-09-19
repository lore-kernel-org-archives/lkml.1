Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXISFdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXISFdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXISFdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:33:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:19054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbXISFdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,271,1186383600"; 
   d="scan'208";a="298253680"
Subject: Re: [PATCH -mm -v2 2/2] i386/x86_64 boot: document for 32 bit boot
	protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46F0B3F4.10701@zytor.com>
References: <1190171428.12429.63.camel@caritas-dev.intel.com>
	 <46F0B3F4.10701@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2007 13:35:10 +0800
Message-Id: <1190180110.12429.65.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 19 Sep 2007 05:33:13.0742 (UTC) FILETIME=[92B3AAE0:01C7FA7E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 22:30 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> > Known issues:
> > 
> > - The hd0_info and hd1_info are deleted from the zero page. Additional
> >   work should be done for this? Or this is unnecessary (because no new
> >   fields will be added to zero page)?
> > 
> 
> For backwards compatibility, they should be marked as there for the
> short-medium term so we don't reuse them for whatever reason.

OK, I will add them back.

Best Regards,
Huang Ying
