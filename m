Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZLNHrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZLNHrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZLNHrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:47:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZLNHrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:47:09 -0500
Message-ID: <4B25EE03.9090303@redhat.com>
Date: Mon, 14 Dec 2009 15:49:23 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gcosta@redhat.com,
       mingo@elte.hu
Subject: Re: [Patch] i386: remove 'usedac' kernel parameter
References: <20091209062850.4245.11541.sendpatchset@localhost.localdomain> <20091209190649I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091209190649I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 9 Dec 2009 01:25:48 -0500
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> It is scheduled to be removed.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Glauber Costa <gcosta@redhat.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>>
>> ---
>> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>> index 591e944..8c895f6 100644
>> --- a/Documentation/feature-removal-schedule.txt
>> +++ b/Documentation/feature-removal-schedule.txt
>> @@ -291,13 +291,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
>>  
>>  ---------------------------
>>  
>> -What:	usedac i386 kernel parameter
>> -When:	2.6.27
>> -Why:	replaced by allowdac and no dac combination
>> -Who:	Glauber Costa <gcosta@redhat.com>
>> -
>> ----------------------------
>> -
> 
> I'm not sure about the above description, I'm not against removing
> this option though.
> 
> IIUC, the usedac option enables us to stop via_no_dac() setting
> forbid_dac to 1. That is, someone who uses VIA bridges can use DAC
> with this option even if some of VIA bridges seem to be broken about
> DAC. I can't see how we can do the same thing with "allowdac" and
> "nodac" combination.


Hmm, yes, right, I missed this point.

Thanks!
