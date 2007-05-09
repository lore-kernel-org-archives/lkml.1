Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbXEII5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbXEII5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbXEII47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:56:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43981 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbXEII45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:56:57 -0400
Date: Wed, 9 May 2007 14:26:12 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, vatsa@in.ibm.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       paulmck@us.ibm.com
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty	realtime processes
Message-ID: <20070509085611.GA4431@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com> <1178545373.28438.7.camel@localhost.localdomain> <877irkrq8a.wl%takeuchi_satoru@jp.fujitsu.com> <1178593345.28438.29.camel@localhost.localdomain> <874pmoro1c.wl%takeuchi_satoru@jp.fujitsu.com> <20070508041033.GB25030@in.ibm.com> <87irb3g4zt.wl%takeuchi_satoru@jp.fujitsu.com> <20070508164850.GS7311@in.ibm.com> <87ejlqg77m.wl%takeuchi_satoru@jp.fujitsu.com> <46411A36.2050609@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46411A36.2050609@yahoo.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 10:47:50AM +1000, Nick Piggin wrote:
> 
> We've seen the same problem with other stop_machine_run sites in the kernel.
> module remove was one.
> 
> Reserving the top priority slot for stop machine (and migration thread, I
> guess) isn't a bad idea.

I second this thought.
The process freezer, if used will only safeguard cpu-hotplug, but not other
sites which use stop_machine_run.

> 
> -- 
> SUSE Labs, Novell Inc.

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
