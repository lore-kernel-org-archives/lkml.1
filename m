Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbYJaRRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbYJaRRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYJaRRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:17:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51936 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYJaRRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:17:32 -0400
Date: Fri, 31 Oct 2008 13:17:21 -0400
From: Dave Jones <davej@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: sched domains oddness.
Message-ID: <20081031171721.GA8837@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20081031162443.GA29885@redhat.com> <1225471911.7803.1596.camel@twins> <20081031170928.GB10468@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031170928.GB10468@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 10:09:29AM -0700, Suresh Siddha wrote:

 > > looks like someone is triggering rebuild_sched_domains(), is something
 > > poking cpusetfs files or flipping between sched_mc settings?
 > 
 > I remember someone mentioning that some distro's started setting
 > sched_mc_power_savings to '1' by default during boot. On a dual-core
 > laptop, this will not give any advantage.
 > 
 > I have to fix the code to not export this tunable, when we have only
 > socket in the system.
 > 
 > Dave, Is your distro also setting this tunable blindly during boot :(

(13:15:25:davej@vaio:~)$ cat /sys/devices/system/cpu/sched_mc_power_savings
0

So no, unless something set it to 1, and then back to 0.

A grep of etc shows up nothing in initscripts.  Does hal or something
play with this?

	Dave

-- 
http://www.codemonkey.org.uk
