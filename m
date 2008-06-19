Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbYFSQTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbYFSQTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYFSQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:19:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:24243 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYFSQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tsXIBzMuYE2jpPEviQGgcJ7CLuclnxeG5Jt3Leuoj40UU+gTZ1eLyG44pXRWZFAbky
         vLHAR10cThiBtIg00GhXX0qeUS6FRfa90sk6OO8XLHskUehHLohBYSuC2h2264iFwAha
         wGqbmtEQTU0E7+JhkKmvCutzQB+u1Q70U0Rv0=
Message-ID: <bc64b4640806190919t23233532o521f33176db2e1bd@mail.gmail.com>
Date: Thu, 19 Jun 2008 20:19:31 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "pHilipp Zabel" <philipp.zabel@gmail.com>
Subject: Re: [PATCH] MFD maintainer
Cc: ian <spyro@f2s.com>, "Samuel Ortiz" <sameo@openedhand.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ben Dooks" <ben-linux@fluff.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <74d0deb30806190906w6f6628b7qb3069c7d97de2192@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080618214223.GE22566@caravaggio>
	 <74d0deb30806190259l2ff7931fo819ededc7aec02f7@mail.gmail.com>
	 <1213872881.17281.32.camel@wirenth>
	 <bc64b4640806190412m70cbb15dr76a25ecb99c245dc@mail.gmail.com>
	 <1213888192.17281.45.camel@wirenth>
	 <bc64b4640806190832s6fd14128o4ef142f06a52fe8b@mail.gmail.com>
	 <74d0deb30806190906w6f6628b7qb3069c7d97de2192@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/19 pHilipp Zabel <philipp.zabel@gmail.com>:
> On Thu, Jun 19, 2008 at 5:32 PM, Dmitry <dbaryshkov@gmail.com> wrote:
>> Hi,
>>
>> 2008/6/19 ian <spyro@f2s.com>:
>>> On Thu, 2008-06-19 at 15:12 +0400, Dmitry wrote:
>>>
>>>> > I'll tidy up the code and pop a branch on my git server for people to
>>>> > review, if thats what people want.
>>>>
>>>> It's better to send patches to some ML.
>>>
>>> Well, the code I had is updated to match linus -git branch
>>> eseries_release7 if anyones curious. (no real changes since last time
>>> though)
>>>
>>>> > Dmitry - if you have any pending patches now is the time to send them on
>>>> > over ;-)
>>>>
>>>> Actually the code I'm using has diverged a bit from the last code I've
>>>> sent before this merging pulse.
>>>
>>> All progress is good :)
>>>
>>>> As you have seen, I've tried to submit parts of the core and tmio-nand
>>>> driver as a start.
>>>
>>> Has any of that got merged yet? If so, I'll adapt my strategy to match
>>> that, otherwise I'll try to keep all the drivers in parallel.
>>>
>>>>  Then I'd suggest to merge other tmio core bits (support for tc6387xb
>>>>  and t7l66xb). The MMC, usb and fb cell drivers could benefit from
>>>>  clocklib patches I'm trying to get in.
>>>
>>> I'd like to see those. I'll get MMC and USB updated ASAP.
>>>
>>> have you solved the clock-api-tied-to-platform-architecture problem ?
>>
>> There were plenty of tries to merge clocklib. Check lkml archives.
>
> How could we stir up some interest in those patches again? The last
> round didn't receive any comments.
>

I don't know :( Maybe I shoud give up the idea of using kobjects, switch back
to kref and do a partial merge of those two patchset branches. I'll think about
it this weekend.

-- 
With best wishes
Dmitry
