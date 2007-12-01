Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbXLAXnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbXLAXnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXLAXnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:43:42 -0500
Received: from rtr.ca ([76.10.145.34]:2019 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbXLAXnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:43:41 -0500
Message-ID: <4751F1AB.2060801@rtr.ca>
Date: Sat, 01 Dec 2007 18:43:39 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: 20000+ wake-ups/second in 2.6.24.   Bug?
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>	<20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca>	<20071130190227.1976e682@laptopd505.fenrus.org>	<4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <4750D899.4020905@rtr.ca>
In-Reply-To: <4750D899.4020905@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Arjan van de Ven wrote:
>> On Fri, 30 Nov 2007 22:31:17 -0500
>> Mark Lord <lkml@rtr.ca> wrote:
...
>>> Speaking of which.. what's with powertop on 2.6.24 ???
>>> It's gone from 100-200 wakeups/sec to 20000 wakeups/sec !!!!!!!
>>
>> ho hum.. Lenovo T61?
>> I have some reports that that happens once in a while (but it's not
>> limited to .24 and it's also real, it's not a powertop bug but it
>> actually is waking up that much)..
> ..
> 
> No, it's my hefty Dell Inspiron 9400.
> 
> And I just figured out the powertop:  it needed the kernel timers
> patch from the powertop site that was originally for 2.6.21..
...

Dagnabbit.. it's done it again.. went from 100-200 wakeups/sec
back up to 20000+ wakeups/sec.  This time *with* the powertop patches in place.

Somethings broken in there, but I don't know what.
Or how to make it happen on demand.. it's fine after rebooting again.

???

At least now I know to look when I hear the fan turning on
when the system is otherwise supposed to be idle..

2.6.23 did not have this problem.
