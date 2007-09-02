Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbXIBHqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbXIBHqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 03:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXIBHqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 03:46:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56269 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbXIBHqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 03:46:23 -0400
Date: Sun, 2 Sep 2007 09:46:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Message-ID: <20070902074622.GA16045@one.firstfloor.org>
References: <20070827215611.GA30396@linux-os.sc.intel.com> <p73bqcmvxc6.fsf@bingen.suse.de> <20070902072806.GC5075@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902072806.GC5075@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> at least the current out-of-idle code already does what amounts to a 
> PM-timer read when exiting from C2 or C3 mode. The 

C2/C3 are already slow. I more worry about C1.

Also doing two instead of one can have an impact even on C2+, especially
when the operation can be thousands of cycles.

-Andi
