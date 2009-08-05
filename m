Return-Path: <linux-kernel-owner+w=401wt.eu-S934575AbZHEOqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbZHEOqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934469AbZHEOqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:46:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54416 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934306AbZHEOqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:46:03 -0400
Message-ID: <4A799B17.2080708@redhat.com>
Date: Wed, 05 Aug 2009 16:45:43 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13809] oprofile: possible circular locking dependency	detected
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.YTD.eHObKB@chimera> <20090803091924.GB25478@erda.amd.com>
In-Reply-To: <20090803091924.GB25478@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> I also tested v2.6.31-rc4 with prove-locking enabled and could not
> trigger the warning. My regression runs fine. Please provide more
> information (workloads, oprofile setup, cpu info, kernel config) to be
> able to reproduce this.
> 
> Thanks,
> 
> -Robert
> 

Hi Robert,

I hit the warning on a dual i686 box, with both v2.6.31-rc2 and v2.6.31-rc4.
I can actually trigger it by just running opcontrol --start and then opreport.
It happens with both --separate=none and --separate=all options (the oprofile
deamon using otherwise default options).
About the kernel config, prove_locking is on, oprofile is a module and
oprofile_ibs is not set. For maor detail, I've attached the config file to
the bugzilla.

I've tried to reproduce it on 2.6.31-rc5 without success.

Regards,
Jerome

> On 26.07.09 22:28:24, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
>> Subject		: oprofile: possible circular locking dependency detected
>> Submitter	: Jerome Marchand <jmarchan@redhat.com>
>> Date		: 2009-07-22 13:35 (5 days old)
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

