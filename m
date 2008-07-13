Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYGMBAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYGMBAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYGMBAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:00:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:48673 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYGMBAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:00:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,352,1212390000"; 
   d="scan'208";a="414385954"
Date: Sat, 12 Jul 2008 18:00:01 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080713010000.GA1678@linux-os.sc.intel.com>
References: <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com> <20080711204521.GA15689@elte.hu> <20080711212418.GV1678@linux-os.sc.intel.com> <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com> <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com> <m163rb4v3j.fsf@frodo.ebiederm.org> <86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 11:17:02PM -0700, Yinghai Lu wrote:
> also read the x2APIC spec pdf, it doesn't say anything about interrupt
> remapping...need to be used with x2apic...

We are updating the spec with more clarifications. But in short,
intr-remapping needs to be enabled prior to enabling x2apic in the CPU.

physical mode might work for < 255 id's for some. But it is HW
implementation specific and might not work from generation to generation.
chipsets or cpu's may drop the interrupts if cpu and chipset are
in different modes (one in legacy mode and another in extended).

So Intel is recommending to enable Intr-remapping before enabling x2apic.

thanks,
suresh
