Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZGKOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZGKOiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZGKOir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 10:38:47 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:62098 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZGKOiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 10:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=whObFga4wSlPwQvkBVy5s29l0WP5/yU6RmwsQ6Ot6xy90b204OoW/TT3AWxGWcTvqK
         b8fUf4XCuq9OY6unIgZJfoRWhqGxnAl3KfAhaaaEMv9eOqAwphn4rJ4yjTDp2PyYig/A
         raejV+pYY2WbcDOodCivLg0Q4HgIIOHF/p7j4=
Message-ID: <4A58A3EB.9040006@gmail.com>
Date: Sat, 11 Jul 2009 16:38:35 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: Re: 2 bugs related to suspend to disk
References: <4A199A7A.3010705@gmail.com> <200905252331.02488.rjw@sisk.pl> <4A1D9A4C.4000600@gmail.com> <200905272247.29098.rjw@sisk.pl>
In-Reply-To: <200905272247.29098.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki pisze:
> On Wednesday 27 May 2009, Marcin Slusarz wrote:
>> Rafael J. Wysocki wrote
>>> On Monday 25 May 2009, Marcin Slusarz wrote:
>>>> Rafael J. Wysocki wrote:
>>>>> On Sunday 24 May 2009, Marcin Slusarz wrote:
>>>>>> Pavel Machek wrote:
>>>>>>> Hi!
>>>>>>>
>>>>>>>
>>>>>>>> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
>>>>>>>>
>>>>>>> I'm afraid we need more details here. Is "resume" binary being ran?
>>>>>> Excellent question ;) - I didn't know it has to. I'll try to setup
>>>>>> initramfs tomorrow.
>>>>>>
>>>>>> Thanks and sorry for the noise!
>>>>> However, the issue reported as 1) is not really a noise IMO. :-)
>>>>>
>>>>> Can you please attach a full dmesg output containing these messages?
>>>> I've uploaded .config, dmesg (BUG was not saved) and 2 pictures of
>>>> screen just before power loss to http://www.kadu.net/~joi/kernel/2009.05.25/
>>>> (Please ignore first suspend failure (3681.078646 - 3685.514358) - I forgot
>>>> to restore swap)
>>> Thanks.
>>>
>>> Can you please test the patch sent by Sebastian Ott in this thread?
>> BUG disappeared with this patch.
> 
> Thanks for testing.
> 
>> Is this a final fix?
> 
> I'm not sure yet.


This bug (first) is still with us as of 2.6.31-rc2-faf80d62e44dc627efb741f48db50c1858d1667c

Marcin
