Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbXI0GEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbXI0GEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXI0GEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:04:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:6701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXI0GEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:04:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,201,1188802800"; 
   d="scan'208";a="287603454"
Subject: Re: [PATCH -mm -v3 1/2] i386/x86_64 boot: setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46F14896.8080603@zytor.com>
References: <1190192306.12429.76.camel@caritas-dev.intel.com>
	 <46F14896.8080603@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Sep 2007 14:06:40 +0800
Message-Id: <1190873200.21818.292.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 27 Sep 2007 06:04:30.0220 (UTC) FILETIME=[44797CC0:01C800CC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

On Wed, 2007-09-19 at 09:04 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> > 
> > Known Issues:
> > 
> > 1. Where is safe to place the linked list of setup_data?
> > Because the length of the linked list of setup_data is variable, it
> > can not be copied into BSS segment of kernel as that of "zero
> > page". We must find a safe place for it, where it will not be
> > overwritten by kernel during booting up. The i386 kernel will
> > overwrite some pages after _end. The x86_64 kernel will overwrite some
> > pages from 0x1000 on.
> > 
> 
> The latter is definitely not safe, since the space below 640K is the
> documented place to put the command line (and presumably where the
> bootloader would put other auxilliary chunks.)
> 
> I'll try to do a full review of this later today.  Haven't had time yet
> to look at this anything than but piecemeal.

Do you think this patch and the 32-bit boot protocol patch are ready to
merge for -mm? If not, I can revise them.

Best Regards,
Huang Ying
