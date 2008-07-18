Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbYGRTFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbYGRTFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYGRTF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:05:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:49961 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbYGRTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CyGbRbJyGGE59tvAoTA7A8Zx2yXwra6M+8W2kS/2H60to7yPK/F33yv6srnzvp9LJK
         fH/5I2RVSQuG1xOeZwB9ju8RVmXA8YC7wRwv3b71mGj5f4Ppb3YYtiCtwzHLOZ3+xJ0y
         ruGiXKkt2E70Nsnf+RYnKFE1JFKG8h3wr3rh0=
Message-ID: <b637ec0b0807181205s509c655cp31a1819e389e2a10@mail.gmail.com>
Date: Fri, 18 Jul 2008 21:05:24 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Justin Mattock" <justinmattock@gmail.com>
In-Reply-To: <4880B959.1030403@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>
	 <b637ec0b0807180217n3b16bcb9wce81161c2c539d7f@mail.gmail.com>
	 <4880B959.1030403@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex. No good news, I'm afraid.

Actually my previous report wasn't correct because with the patch I
mentioned the message appeared yesterday night during the hibernate
process, so I couldn't notice it.

 The interesting thing is that it showed up the day after I booted my
laptop: usually it took a period between 1 and 13 minutes after boot
to trigger and in this case it took more than 2 hours of uptime with 2
suspend and 2 hibernate cycles.

With the patch you told me to apply and the previous reverted the
message triggered in 12 minutes.

Regards,
Fabio




On Fri, Jul 18, 2008 at 5:40 PM, Alexey Starikovskiy
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
