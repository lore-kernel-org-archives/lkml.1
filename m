Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbYGRUiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbYGRUiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYGRUhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:37:51 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:35803 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757317AbYGRUhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:37:50 -0400
Message-ID: <4880FF24.4000303@suse.de>
Date: Sat, 19 Jul 2008 00:37:56 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Fabio Comolli <fabio.comolli@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Mattock <justinmattock@gmail.com>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>	 <b637ec0b0807180217n3b16bcb9wce81161c2c539d7f@mail.gmail.com>	 <4880B959.1030403@suse.de> <b637ec0b0807181205s509c655cp31a1819e389e2a10@mail.gmail.com>
In-Reply-To: <b637ec0b0807181205s509c655cp31a1819e389e2a10@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

There are no bad news in seeing the message, as I tried to say several
times in bug report already. We can't fix the hardware.
We only could detect hardware flaw, report it (the message), and try to
workaround it.
So the bad news would be that our workaround causes some unwanted behavior to
other features of notebook -- keyboard, special keys, battery & AC status reports, etc.
If no such problems were noticed -- there is no bug, and there is no problem.

Regards,
Alex.

Fabio Comolli wrote:
> Hi Alex. No good news, I'm afraid.
> 
> Actually my previous report wasn't correct because with the patch I
> mentioned the message appeared yesterday night during the hibernate
> process, so I couldn't notice it.
> 
>  The interesting thing is that it showed up the day after I booted my
> laptop: usually it took a period between 1 and 13 minutes after boot
> to trigger and in this case it took more than 2 hours of uptime with 2
> suspend and 2 hibernate cycles.
> 
> With the patch you told me to apply and the previous reverted the
> message triggered in 12 minutes.
> 
> Regards,
> Fabio
> 
> 
> 
> 
> On Fri, Jul 18, 2008 at 5:40 PM, Alexey Starikovskiy
> <astarikovskiy@suse.de> wrote:
>> Fabio,
>> Please try http://bugzilla.kernel.org/attachment.cgi?id=16862 instead.
>> Same bug entry, last patch.
>> Regards,
>> Alex.
>> Fabio Comolli wrote:
>>> Hi.
>>> I also have this problem with 2.6.26 and when it happens I can notice
>>> that sometimes gnome-power-manager is slow to respond when I switch to
>>> AC from battery and viceversa. Also, sometimes the g-p-m icon
>>> disappears and I have to restart the process.
>>>
>>> I tried two days ago the patch
>>>
>>>   http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>>>
>>> and everything seems to work ok since then. Before that, the message
>>> showed up sometimes at boot time, sometimes minutes later, very
>>> reliably.
>>>
>>> This is with a two years old fairly standard HP laptop.
>>>
>>> Regards,
>>> Fabio
>>>
>>>
>>> On Sun, Jul 13, 2008 at 8:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>> This message has been generated automatically as a part of a report
>>>> of recent regressions.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> from 2.6.25.  Please verify if it still should be listed.
>>>>
>>>>
>>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
>>>> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
>>>> Submitter       : Justin Mattock <justinmattock@gmail.com>
>>>> Date            : 2008-05-16 6:17 (59 days old)
>>>> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>>>>                 http://lkml.org/lkml/2008/5/18/168
>>>>                 http://lkml.org/lkml/2008/5/25/195
>>>> Patch           :
>>>> http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>>>>
>>>> http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>

