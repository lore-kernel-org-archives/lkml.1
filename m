Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZDPXgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZDPXgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbZDPXgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:36:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:38806 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbZDPXgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,200,1239001200"; 
   d="scan'208";a="682281840"
Subject: Re: [PATCH 8/8] irq: make ht irq_desc numa aware
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090416092137.GK9813@elte.hu>
References: <49E68C41.4020801@kernel.org> <49E68D7F.7060209@kernel.org>
	 <20090416092137.GK9813@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 16 Apr 2009 16:34:58 -0700
Message-Id: <1239924898.27006.8466.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 02:21 -0700, Ingo Molnar wrote:
> The whole series has become very reasonable (modulo the minor 
> structure and Cc: related comments i made).
> 
> It's obviously too late in .30 to push it upstream, so the best 
> action is to mark it broken upstream, then remove + rewrite it in 
> the IRQ tree and we'll have all this done properly in v2.6.31.
> 
> Thomas, Eric, Suresh, what do you think?

Instead of marking the NUMA_MIGRATE_IRQ_DESC config option broken, I
would like to see it removed in 2.6.30 (i.e., apply the first patch in
this patchset for 2.6.30). As this simplifies quite a bit of code, this
will help anyone debugging a problem in this irq handling area, during
the life span of any distro carrying this kernel version.

thanks,
suresh

