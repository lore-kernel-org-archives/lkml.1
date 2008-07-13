Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYGMBcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYGMBcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYGMBcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:32:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:54437 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYGMBcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,352,1212390000"; 
   d="scan'208";a="414427198"
Date: Sat, 12 Jul 2008 18:32:44 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
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
Message-ID: <20080713013244.GF1678@linux-os.sc.intel.com>
References: <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com> <20080711204521.GA15689@elte.hu> <20080711212418.GV1678@linux-os.sc.intel.com> <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com> <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com> <m163rb4v3j.fsf@frodo.ebiederm.org> <86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com> <m1y7471t5t.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y7471t5t.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 12:02:54AM -0700, Eric W. Biederman wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> > also read the x2APIC spec pdf, it doesn't say anything about interrupt
> > remapping...need to be used with x2apic...
> 
> Clustered logical mode won't work as it requires > 16 bits of apicid.
> So only flat physical mode will work.

Eric, As I mentioned just now in another thread, even flat physical mode
might not work, if cpu or chipset thinks that they are in different modes.

For example if CPU is in extended mode, chipset may block non-remapped
intr-messages and not fwd these to the cpu. So while in theory, physical mode
for < 255 apic id's may work, Intel is not validating and not recommending to
enable x2apic mode in the CPU with out enabling intr-remapping in the chipset.

thanks,
suresh
