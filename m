Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbZFKGsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbZFKGsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbZFKGsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:48:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:61636 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbZFKGsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,200,1243839600"; 
   d="scan'208";a="465380379"
Subject: Re: [PATCH -v5] x86: MCE: Re-implement MCE log ring buffer as
 per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A30A779.4040101@jp.fujitsu.com>
References: <1244445115.8361.576.camel@yhuang-dev.sh.intel.com>
	 <4A30A779.4040101@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 14:48:25 +0800
Message-Id: <1244702905.5320.9.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 14:43 +0800, Hidetoshi Seto wrote:
> Huang Ying wrote:
> > Re-implement MCE log ring buffer as per-CPU ring buffer for better
> > scalability.
> 
> It seems your patch implicitly includes some bug fix for tip/mce3.
> Still discussion of generic lockless ring buffer is going on, so how
> about dividing the patch into 2 pieces, for improvement and for bug fix?
> 
> Maybe improvement part need to be reworked, so I pulled out the bug fix
> part from your patch.
> 
> If it's all right, I'd like to put this on top of tip/mce3 asap.

It is OK for me.

Best Regards,
Huang Ying

