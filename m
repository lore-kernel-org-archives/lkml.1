Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbXLAECx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbXLAECx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 23:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXLAECj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 23:02:39 -0500
Received: from rtr.ca ([76.10.145.34]:3447 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbXLAECi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 23:02:38 -0500
Message-ID: <4750DCDC.8030306@rtr.ca>
Date: Fri, 30 Nov 2007 23:02:36 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>	<20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca>	<20071130190227.1976e682@laptopd505.fenrus.org>	<4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <4750D899.4020905@rtr.ca>
In-Reply-To: <4750D899.4020905@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 30 Nov 2007 22:44:25 -0500
> Mark Lord <lkml@rtr.ca> wrote:
>>> all you need to do in your kernel module is call
>>>
>>> add_latency_constraint("mark_wants_his_mouse", 5);
>> Okay, and how to change it back again?  (thanks)
> 
> 
> sorry I misremember it's called
> set_acceptable_latency("mark", 5);
> 
> and to remove the constraint again you just do
> 
> remove_acceptable_latency("mark");
> 
> (and there's modify_ too to change existing)
> 
>> Then why not have a sysfs entry for scripts to write tsoro
>> to trigger the exact same end result?  :)
> 
> that's what is in current -mm pretty much
> well not sysfs, but it goes via a file descriptor
> (so that if the process that sets the contraint dies, the latency
> requirement can be given up automatically)
...

But doesn't that approach also make it nearly impossible to script ????

Having to hack source for any apps that one wants to use it on
sounds rather barbaric.. 

(sure I *can* still script it, with background tasksand wait and ..
 but that's getting rather complex again).

Meanwhile.. I'll now cook up a module to try the set/remove_acceptable_latency thing.

Thanks
