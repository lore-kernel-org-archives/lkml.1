Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbYGOS1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbYGOS1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYGOS1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:27:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:26227 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbYGOS1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:27:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,367,1212390000"; 
   d="scan'208";a="315559852"
Date: Tue, 15 Jul 2008 11:27:39 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Message-ID: <20080715182739.GB18203@linux-os.sc.intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <200807132219.35814.yhlu.kernel@gmail.com> <20080715173318.GA18203@linux-os.sc.intel.com> <86802c440807151110vf814830r9bf0e9d50f559e1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807151110vf814830r9bf0e9d50f559e1d@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:10:37AM -0700, Yinghai Lu wrote:
> On Tue, Jul 15, 2008 at 10:33 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > Yinghai, Looking more closely at this, based on my understanding this might be
> > wrong for VMI. Correct patch should be as follows. Any comments?
> 
> so you mean icr related will still use default native member?

Yes. This is similar to pre apic_ops.

I think VMI uses apic operations in the paravirt case. For example,
please refer to vmi_time_bsp_init/vmi_time_ap_init.

thanks,
suresh
