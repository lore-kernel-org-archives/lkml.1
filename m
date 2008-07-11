Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbYGKB4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbYGKB4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYGKB4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:56:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:27878 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbYGKB4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:56:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,341,1212390000"; 
   d="scan'208";a="12238609"
Date: Thu, 10 Jul 2008 18:56:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 21/26] x64, x2apic/intr-remap: setup init_apic_ldr for UV
Message-ID: <20080711015621.GQ1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710182238.916522000@linux-os.sc.intel.com> <20080710171430.b15306a3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710171430.b15306a3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 05:14:30PM -0700, Andrew Morton wrote:
> On Thu, 10 Jul 2008 11:16:55 -0700 Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > +static inline void uv_init_apic_ldr(void)
> > +{
> > +}
> > +
> >  static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
> >  {
> >       int cpu;
> > @@ -164,6 +168,7 @@
> >       .target_cpus = uv_target_cpus,
> >       .vector_allocation_domain = uv_vector_allocation_domain,/* Fixme ZZZ */
> >       .apic_id_registered = uv_apic_id_registered,
> > +     .init_apic_ldr = uv_init_apic_ldr,
> 
> There's no point in declaring it inline if it's always called indirectly.

oops. will fix it.

thanks,
suresh
