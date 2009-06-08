Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZFHHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZFHHaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZFHHaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:30:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:54921 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZFHHaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:30:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,323,1241420400"; 
   d="scan'208";a="464356772"
Subject: Re: [PATCH -v5] x86: MCE: Re-implement MCE log ring buffer as
 per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090608072030.GA6732@elte.hu>
References: <1244445115.8361.576.camel@yhuang-dev.sh.intel.com>
	 <20090608072030.GA6732@elte.hu>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 15:30:22 +0800
Message-Id: <1244446222.8361.584.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 15:20 +0800, Ingo Molnar wrote:
> * Huang Ying <ying.huang@intel.com> wrote:
> 
> > Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> > scalability.
> 
> this should be done using the generic ring-buffer code - see 
> include/linux/ring_buffer.h. Having a private implementation in 
> architecture code is not really acceptable.

MCE log ring buffer need to be NMI-safe, while current generic
ring-buffer code is not NMI safe. Maybe we can use the generic
ring-buffer code after it goes NMI-safe. But for now, I think this patch
is better.

Best Regards,
Huang Ying


