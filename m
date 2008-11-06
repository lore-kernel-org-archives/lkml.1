Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbYKFImm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbYKFImm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYKFIme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:42:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYKFIme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:42:34 -0500
Date: Thu, 6 Nov 2008 09:42:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jens.axboe@oracle.com, jeremy.fitzhardinge@citrix.com,
       nickpiggin@yahoo.com.au, torvalds@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [patch 2/3] x86: Add smp_mb() before sending
	INVALIDATE_TLB_VECTOR
Message-ID: <20081106084211.GA4890@elte.hu>
References: <20081104215626.751033000@linux-os.sc.intel.com> <20081104215626.897026000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104215626.897026000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On x86, x2apic mode accesses for sending IPI's don't have 
> serializing semantics. If the IPI receiver refers(in lock-free 
> fashion) to some memory setup by the sender, the need for smp_mb() 
> before sending the IPI becomes critical in x2apic mode.
> 
> Add the smp_mb() in native_flush_tlb_others() before sending the 
> IPI.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

applied to tip/x86/urgent, thanks Suresh!

Jens, you'll send 1/3 and 3/3 to Linus, right?

	Ingo
