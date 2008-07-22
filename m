Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYGVTRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYGVTRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYGVTRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:17:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:63623 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYGVTRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:17:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,232,1215414000"; 
   d="scan'208";a="363813657"
Date: Tue, 22 Jul 2008 12:17:09 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
Message-ID: <20080722191708.GE14380@linux-os.sc.intel.com>
References: <200807211836.27282.yhlu.kernel@gmail.com> <200807212208.22116.yhlu.kernel@gmail.com> <20080722175757.GC14380@linux-os.sc.intel.com> <86802c440807221105s77372df8re2e59440a8f644bd@mail.gmail.com> <20080722181056.GD14380@linux-os.sc.intel.com> <86802c440807221140o20dcc31fjc10f86a22a1125bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807221140o20dcc31fjc10f86a22a1125bb@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:40:13AM -0700, Yinghai Lu wrote:
> could be apic mode is set to phys flat mode by BIOS.
> 
> get
> APIC error (0x40)...

Does this happen while sending IPI's? AP bringup should be same
irrespective of the genapic mode we select here.

> that is the reason for introducing max_phys_apicid.

We may need a workaround if it is some cpu/platform specific issue. But we
need to understand the actual issue and document it properly, so that
it doesn't break in the future.

thanks,
suresh
