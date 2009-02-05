Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZBEKVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZBEKVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZBEKVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:21:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:59944 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbZBEKVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:21:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,384,1231142400"; 
   d="scan'208";a="384162368"
Subject: Re: [PATCH NET-NEXT 01/10] clocksource: allow usage independent of
	timekeeping.c
From: Patrick Ohly <patrick.ohly@intel.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: john stultz <johnstul@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233793093.15119.147.camel@desktop>
References: <1233752517-30010-1-git-send-email-patrick.ohly@intel.com>
	 <1233752517-30010-2-git-send-email-patrick.ohly@intel.com>
	 <1233756235.15119.54.camel@desktop> <1233758796.15940.198.camel@ecld0pohly>
	 <1233760170.15119.76.camel@desktop>
	 <1233775542.6994.13.camel@localhost.localdomain>
	 <1233776421.15119.125.camel@desktop>
	 <1233777982.6994.51.camel@localhost.localdomain>
	 <1233781499.15119.135.camel@desktop>
	 <1233782100.6994.82.camel@localhost.localdomain>
	 <1233793093.15119.147.camel@desktop>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 11:21:05 +0100
Message-Id: <1233829265.20435.38.camel@pohly-MOBL>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 02:18 +0200, Daniel Walker wrote:
> > Plus he adds other accessors to the clocksource structure that are not
> > compatible with the clocksources registered for timekeeping.
> 
> It's akin to vread, I think. I'd prefer to see the read() used
> instead,
> but I can see why there could be a need for a structure getting
> passed.

There is indeed: the igb driver supports multiple different interfaces.
Each interface has its own NIC time, so the callback needs the
additional pointer to find out which NIC time it is expected to read.

Regarding the rest of the discussion: I understand that it is useful to
have it and perhaps get serious about refactoring clocksource, but I
also hope that this will not delay including the patches. They are
needed for HW time stamping now and cannot wait for the clocksource
refactoring.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.


