Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYGNSDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYGNSDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYGNSDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:03:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:49003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYGNSDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:03:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,360,1212390000"; 
   d="scan'208";a="315171017"
Date: Mon, 14 Jul 2008 11:03:40 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Message-ID: <20080714180339.GL1678@linux-os.sc.intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <200807132219.35814.yhlu.kernel@gmail.com> <20080714071207.GB17077@elte.hu> <20080714164913.GK1678@linux-os.sc.intel.com> <86802c440807141000x106cf885s6de0aad9804112bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807141000x106cf885s6de0aad9804112bf@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 10:00:28AM -0700, Yinghai Lu wrote:
> On Mon, Jul 14, 2008 at 9:49 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > [patch] x86: apic_ops for lguest
> >
> > apic_ops for lguest.
> >
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> do we need one for KVM pv?

No. They use different op's for complete apic virt.

thanks,
suresh
