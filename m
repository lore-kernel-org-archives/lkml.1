Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbXLADbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbXLADbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 22:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbXLADbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 22:31:20 -0500
Received: from rtr.ca ([76.10.145.34]:3321 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569AbXLADbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 22:31:19 -0500
Message-ID: <4750D585.1030200@rtr.ca>
Date: Fri, 30 Nov 2007 22:31:17 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>	<20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca>	<20071130190227.1976e682@laptopd505.fenrus.org>	<4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org>
In-Reply-To: <20071130191816.3e744205@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 30 Nov 2007 22:14:08 -0500
> Mark Lord <lkml@rtr.ca> wrote:
> 
>>> in -mm there is.. the QoS stuff allows you to set maximum tolerable
>> ..
>>
>> That's encouraging, I think, but not for 2.6.24.
>>
>>> latency. If your app cant take any latency, you should set those...
>>> and the side effect is that the kernel will not do long-latency
>>> C-states or P-state transitions..
>> ..
>>
>> I don't mind the cpufreq changing (actually, I want it to drop in
>> cpugfreq to save power and keep the fan off), but the C-states just
>> kill this app.
>>
>> The app is VMware.  I force the max_state=1 when launching,
> 
> ah but then its' even easier... and can be done in 2.6.24 already.
> VMWare after all has a kernel module, and the latency stuff is in
> 2.6.23 and 2.6.24 available inside the kernel already.
..

Oh, I'm perfectly happy to write my own kernel module if that's what
is going to be needed here, but just doing an echo into sysfs was simpler.
But yes, it appears to have no effect even with the chmod patch I posted,
so something different is needed here.

>> I'm not sure about C?? -- it could be C8 or even be C2 or whatever.
>> I suppose I should find out, but that really takes a lot of fuss
>> (hours) to measure, and isn't strictly repeatable.
> 
> (also hope you don't have one of those AMD machines where the bios
> turns C1 into C2/C3/etc behind the OSes back ;-)
..

Just a nice Intel Core2 Duo notebook.

Speaking of which.. what's with powertop on 2.6.24 ???
It's gone from 100-200 wakeups/sec to 20000 wakeups/sec !!!!!!!

New thread time..
