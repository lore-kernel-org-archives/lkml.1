Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYKFIpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYKFIpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYKFIo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:44:57 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:53917 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYKFIo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:44:57 -0500
Date: Thu, 6 Nov 2008 09:43:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, jeremy.fitzhardinge@citrix.com,
       nickpiggin@yahoo.com.au, torvalds@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [patch 2/3] x86: Add smp_mb() before sending INVALIDATE_TLB_VECTOR
Message-ID: <20081106084331.GY21867@kernel.dk>
References: <20081104215626.751033000@linux-os.sc.intel.com> <20081104215626.897026000@linux-os.sc.intel.com> <20081106084211.GA4890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106084211.GA4890@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06 2008, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > On x86, x2apic mode accesses for sending IPI's don't have 
> > serializing semantics. If the IPI receiver refers(in lock-free 
> > fashion) to some memory setup by the sender, the need for smp_mb() 
> > before sending the IPI becomes critical in x2apic mode.
> > 
> > Add the smp_mb() in native_flush_tlb_others() before sending the 
> > IPI.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> applied to tip/x86/urgent, thanks Suresh!
> 
> Jens, you'll send 1/3 and 3/3 to Linus, right?

Yes, it's in for-linus and I'll send the pull request today.

-- 
Jens Axboe

