Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbYGRQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbYGRQXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbYGRQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:23:12 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:17446 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYGRQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kqszZ2rE8sNsyZO4KJzKjx03JSKfRBeIZffjntG4hNkZGp6K6s9S+NDm7Ja8NWK0rR
         UifhAzwgbE6FkiLGMhPMXKvNu6Vg+szB/NcVrSZ/4rLCDB60nlHdXQ+A8CRfTenQMLvw
         HVIZ7TDFTG3oiwMTz90VOOOXs00qH6qDiwoBM=
Message-ID: <dd18b0c30807180923p105697b4r7d95c40b3d66c84e@mail.gmail.com>
Date: Fri, 18 Jul 2008 16:23:09 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Fabio Comolli" <fabio.comolli@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <4880B959.1030403@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>
	 <b637ec0b0807180217n3b16bcb9wce81161c2c539d7f@mail.gmail.com>
	 <4880B959.1030403@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 3:40 PM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> Fabio,
> Please try http://bugzilla.kernel.org/attachment.cgi?id=16862 instead.
> Same bug entry, last patch.
> Regards,
> Alex.
> Fabio Comolli wrote:
>>
>> Hi.
>> I also have this problem with 2.6.26 and when it happens I can notice
>> that sometimes gnome-power-manager is slow to respond when I switch to
>> AC from battery and viceversa. Also, sometimes the g-p-m icon
>> disappears and I have to restart the process.
>>
>> I tried two days ago the patch
>>
>>   http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>>
>> and everything seems to work ok since then. Before that, the message
>> showed up sometimes at boot time, sometimes minutes later, very
>> reliably.
>>
>> This is with a two years old fairly standard HP laptop.
>>
>> Regards,
>> Fabio
>
>>
>>
>>
>> On Sun, Jul 13, 2008 at 8:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.25.  Please verify if it still should be listed.
>>>
>>>
>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
>>> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
>>> Submitter       : Justin Mattock <justinmattock@gmail.com>
>>> Date            : 2008-05-16 6:17 (59 days old)
>>> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>>>                 http://lkml.org/lkml/2008/5/18/168
>>>                 http://lkml.org/lkml/2008/5/25/195
>>> Patch           :
>>> http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>>>
>>> http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>
>

I tried this patch; and for some reason
I'm still seeing this message(that is when using
acpi_osi=Linux). The problem I see is we've got different brands
of laptops, and the causes are all different.
In my case I'm wondering if there is a way to tweak the interrupts
with the battery. just to see if this works

-- 
Justin P. Mattock
