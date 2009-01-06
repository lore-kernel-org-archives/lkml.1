Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZAFUev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZAFUev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZAFUel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:34:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:48594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbZAFUek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:34:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,221,1231142400"; 
   d="scan'208";a="479422328"
From: "Luck, Tony" <tony.luck@intel.com>
To: Robin Holt <holt@sgi.com>
CC: Dimitri Sivanich <sivanich@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>
Date: Tue, 6 Jan 2009 12:34:06 -0800
Subject: RE: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Thread-Topic: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Thread-Index: AclwPC5k6IBw6MW9Te2lgpXylAJfvQAANFfg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35CB955B4@orsmsx505.amr.corp.intel.com>
References: <20090106162741.GA7991@sgi.com>
 <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com>
 <20090106201950.GA3850@sgi.com>
In-Reply-To: <20090106201950.GA3850@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > All ia64 systems are potentially affected ... but perhaps you might
> > never see the problem on most because the itc clocks are synced as close
> > as s/w can get them when cpus are brought on line.
>
> Do you want Dimitri to resubmit with this set for all IA64 or leave it
> as is?

I'd like to understand the impact of turning on HAVE_UNSTABLE_SCHED_CLOCK

It looks like both the i386_defconfig and x86_64_defconfig choose this,
so at least ia64 will be hitting the well tested code paths

Have the other architectures just not hit this yet?  Or do they all have
"stable" sched_clock() functions?


sched_clock() seemed like such a straightforward thing to begin with. A
quick & easy way to measure a time delta ON THE SAME CPU.  I'm not at
all sure why it has been co-opted for general time measurement.

-Tony
