Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZKBRfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZKBRfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbZKBRfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:35:44 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42275 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbZKBRfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:35:41 -0500
Date: Mon, 2 Nov 2009 09:35:41 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/6] x86: cleanups and fixes for irq migration code
	during cpu offline
Message-ID: <20091102173541.GA7464@us.ibm.com>
References: <20091026222430.313656103@sbs-t61.sc.intel.com> <1256930729.2679.10.camel@sbs-t61.sc.intel.com> <20091102145938.GD23776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102145938.GD23776@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:59:38PM +0100, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > On Mon, 2009-10-26 at 15:24 -0700, Siddha, Suresh B wrote:
> > > First four patches in the series unify the fixup_irqs() along with
> > > couple of cleanups. It also fixes an issue where the interrupt subsystem can 
> > > point the interrupt to the offlined cpu (for non interrupt-remapping case)
> > > causing the device to not work. This was observed by Gary.
> > > 
> > > These four patches are ready for inclusion
> > 
> > Ingo, if no one has any objections, can you please consider the first 
> > four patches in this patchset for -tip testing?
> 
> Yep, queued them up. I went for the whole batch as it looks good and 
> needs wider testing as well.
> 
> Note, i fixed a few small details in patch #5.
> 
> Note #2, the signoffs from Gary looked weird - they were put last while 
> the patches did not come from him. I changed those to Acked-by -

Thats fine with me.  I was involved to a minor extent
in the development of the patches but I think my biggest
contribution was testing.

BTW, looks like "[patch 1/6] x86: unify fixup_irqs() for 32-bit
and 64-bit kernels" got committed without this change.

Thanks for giving them a chance.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

