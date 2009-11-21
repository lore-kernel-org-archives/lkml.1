Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZKUUrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZKUUrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 15:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZKUUra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 15:47:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59512 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZKUUr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 15:47:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Hy6STpMZsod43d0+orR1DbSVSMFytaxqtr8juJgvJK4CNzfCf/gCYLqMcvtyx83WVF
         CcP1BVjj7Vzr0sBZu4oWoIbOcKU2eXhERogk9pyHW2nEBHX7HgqCkkeLh69Vc6QM6PZ+
         LT5O52+g7zQLyt0IsJjDEmmjg3woJ2dYYG17U=
Message-ID: <4B085218.7080907@gmail.com>
Date: Sat, 21 Nov 2009 12:48:24 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>	<mYW9sxtWd2G.A.EnF.gDACLB@chimera>	<4B08258E.9050607@gmail.com> <20091121200442.61740f37.kristoffer.ericson@gmail.com>
In-Reply-To: <20091121200442.61740f37.kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson wrote:
> On Sat, 21 Nov 2009 09:38:22 -0800
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>    
>> Rafael J. Wysocki wrote:
>>      
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.30 and 2.6.31.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>>> be listed and let me know (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
>>> Subject		: Disassociating atheros wlan
>>> Submitter	: Kristoffer Ericson<kristoffer.ericson@gmail.com>
>>> Date		: 2009-09-24 10:16 (59 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4
>>>
>>>
>>>
>>>
>>>        
>> I did a bisect yesterday on this, and the results
>> seemed to have worked over here by reverting:
>>
>> 75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
>> cfg80211: lower dynamic PS timeout to 100ms
>>
>> if Kristoffer can try reverting this one
>> to see, then we can go from there.
>>      
>
> In the process of doing that as we speak.
>
>    
>> Justin P. Mattock
>>
>>
>>
>>      
>
>
>    
cool..

Justin P. Mattock
