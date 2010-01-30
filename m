Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432Ab0A3UAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0A3UAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907Ab0A3UAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:00:13 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:41238 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0A3UAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:00:12 -0500
Date: Sat, 30 Jan 2010 15:00:24 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Regressionhung task during raid rebuild 2.6.33 rc5 was: Re:
 2.6.33RC3 hung task - jbd2/dm-1-8 (during raid rebuild)
In-reply-to: <201001302057.59529.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Message-id: <4B648FD8.6060904@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7BIT
References: <4B4A4AD7.5090800@majjas.com> <4B6486A7.8030404@majjas.com>
 <201001302057.59529.rjw@sisk.pl>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2010 2:57 PM, Rafael J. Wysocki wrote:
> On Saturday 30 January 2010, Michael Breuer wrote:
>    
>> On 1/10/2010 4:47 PM, Michael Breuer wrote:
>>      
>>> System crashed (watchdog reset).
>>>
>>> Was doing a raid rebuild at the time (raid6).
>>>
>>> I typed, 'yumdownloader --source virtlib' ... system froze, then
>>> rebooted on the watchdog reset.
>>>
>>> I've attached the log extract from the event as well as dmesg.
>>>
>>>
>>>        
>> Hit this again - system doesn't crash now - just get the hung task
>> warning (log extract attached). System seems to keep running (albeit the
>> rebuild is incredibly slow on 2.6.33 rc5 - approx 6500K/sec vs. about
>> 80,000K/sec on 2.6.32.4.
>>
>> Looks like it may be triggered by disk io during the rebuild. This time
>> I had typed, "sync." "sync" hung for a long while but did eventually
>> complete.
>>      
> Is this the bug tracked as http://bugzilla.kernel.org/show_bug.cgi?id=15125 ?
>
> Rafael
>    
Yes - although the behavior is different on rc5 vs. rc3. I think it's 
the same.
