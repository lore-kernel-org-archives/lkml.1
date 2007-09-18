Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXIRBKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXIRBKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 21:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXIRBJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 21:09:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:22898 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbXIRBJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 21:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,266,1186383600"; 
   d="scan'208";a="297228473"
Subject: Re: [RFC -mm 1/2] i386/x86_64 boot: setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46EE9D94.9030608@zytor.com>
References: <1190017578.5866.21.camel@caritas-dev.intel.com>
	 <46EE9D94.9030608@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 09:11:47 +0800
Message-Id: <1190077907.12429.5.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 18 Sep 2007 01:09:53.0447 (UTC) FILETIME=[9E943B70:01C7F990]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 08:30 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> > This patch add a field of 64-bit physical pointer to NULL terminated
> > single linked list of struct setup_data to real-mode kernel
> > header. This is used to define a more extensible boot parameters
> > passing mechanism.
> 
> You MUST NOT add a field like this without changing the version number,
> and, since you expect to enter the kernel at the PM entrypoint, you
> better *CHECK* that version number before ever descending down the chain.
> 

I forgot changing the version number in boot/head.S. I will add it. And
I will add version number checking before descending down the chain.

Best Regards,
Huang Ying
