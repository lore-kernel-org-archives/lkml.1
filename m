Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875Ab0AKVzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0AKVzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289Ab0AKVzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:55:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:27334 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab0AKVzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:55:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,258,1262592000"; 
   d="scan'208";a="483155773"
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "ananth@in.ibm.com" <ananth@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <86802c441001111343p2afaafb7o702884e632260bf7@mail.gmail.com>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
	 <20100110102638.GA7838@elte.hu>
	 <86802c441001111343p2afaafb7o702884e632260bf7@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 11 Jan 2010 13:53:49 -0800
Message-Id: <1263246829.2859.537.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 13:43 -0800, Yinghai Lu wrote:
> On Sun, Jan 10, 2010 at 2:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > In any case this commit needs to be reverted as the assumption that it's safe
> > to do this optimization is evidently not true.
> >
> 
> use attached debug patch on one of my intel system and with nr_cpus=8,
> it seems logical flat works.
> that system BSP apic id is 0x20.

Same here. I don't see any issues with my testing on two different
platforms.

This sounds more like an IBM platform issue. So reverting the 2fbd07a5f
commit is not the correct solution.

thanks,
suresh

