Return-Path: <linux-kernel-owner+w=401wt.eu-S934529AbXHZACW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529AbXHZACW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 20:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbXHZACM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 20:02:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38666 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXHZACL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 20:02:11 -0400
Date: Sat, 25 Aug 2007 16:57:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <abelay@novell.com>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070825165701.8423f5e6.randy.dunlap@oracle.com>
In-Reply-To: <46D0BA9D.1080708@imap.cc>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CF695D.1020008@imap.cc>
	<20070824170702.a2c51084.akpm@linux-foundation.org>
	<653FFBB4508B9042B5D43DC9E18836F5014D954E@scsmsx415.amr.corp.intel.com>
	<653FFBB4508B9042B5D43DC9E18836F5014D956A@scsmsx415.amr.corp.intel.com>
	<46D0BA9D.1080708@imap.cc>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007 01:26:21 +0200 Tilman Schmidt wrote:

> Am 25.08.2007 02:38 schrieb Pallipadi, Venkatesh:
> >>
> >>>> FATAL: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-testing/kernel/drivers/acpi/processor.ko): Input/output error
> >>>> WARNING: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-testing/kernel/drivers/acpi/processor.ko): Input/output error
> > 
> > This is indeed related to CPUIDLE.
> > 
> > Tilman: Can you configure CONFIG_CPU_IDLE in your config (under Power
> > Management option) and double check that the frequency part works after
> > that.
> 
> Strangely enough, I do not see that option in "make xconfig".
> The "Power Management" subtree ends with "CPU Frequency scaling".
> In "make menuconfig" the option is there, though.

That sounds strange.  Please share your .config file.

> After activating it, these two errors are indeed gone, and the
> "thermal: Unknown symbol acpi_processor_set_thermal_limit" one
> as well.



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
