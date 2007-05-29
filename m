Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbXE2SO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbXE2SO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXE2SOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:14:18 -0400
Received: from 125.14.124.24.cm.sunflower.com ([24.124.14.125]:27076 "EHLO
	mail.atipa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751912AbXE2SOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:14:17 -0400
Message-ID: <465C6D78.9030009@atipa.com>
Date: Tue, 29 May 2007 13:14:16 -0500
From: Roger Heflin <rheflin@atipa.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Apparent Deadlock with nfsd/jfs on 2.6.21.1 under bonnie.
References: <4649BED9.6090207@atipa.com>	 <pan.2007.05.15.22.03.07.359081@linux.vnet.ibm.com>	 <464C68A0.2050003@atipa.com>	 <1179413287.13965.24.camel@kleikamp.austin.ibm.com>	 <465C5FDF.4070401@atipa.com> <1180462215.10013.2.camel@kleikamp.austin.ibm.com>
In-Reply-To: <1180462215.10013.2.camel@kleikamp.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2007 18:16:59.0171 (UTC) FILETIME=[8C1B7730:01C7A21D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:
> On Tue, 2007-05-29 at 12:16 -0500, Roger Heflin wrote:
> 
>> Dave,
>>
>> Apparently there appears to be another different similar lockup,
>> The MTBF has risen from 1-2 hours without that patch to >100 hours,
>> so I am fairly sure the patch did correct the original lockup, or
>> at the very least make it a lot less likely.
>>
>> I hit the machine across NFS for 5 days before it deadlocked, before
>> the patch I could only get an hour or two (2-4 different tries).
>>
>> Given that pdflush is "D" it does not appear to be an NFS issue.
>>
>> Included is the sysrq-t.
>>
>> This is with 2.6.21.1 + the JFSIO patch.
> 
> Is the system still in this state?  Can you cat /proc/fs/jfs/TxAnchor
> (if CONFIG_JFS_DEBUG is defined) and /proc/fs/jfs/txstats (if
> CONFIG_JFS_STATISTICS is defined)?
> 
> Thanks,
> Shaggy

Yes, the machine is still in that state.

Apparently I don't have either of those configured.

Anything else that we can collect before I rebuild the kernel with
those options setup?

                              Roger

