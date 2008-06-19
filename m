Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbYFSQRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbYFSQRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYFSQQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:16:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:22215 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760293AbYFSQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uPR1FwSXtmCwS+/4I2w1LfHjJAi/1oUjike3d5PF3Ize9TTb3WBQonhtm9m0ABB7oU
         gNtexj1kAJe+6mS+iGnAswOlq93iIcXwLw+qmVHSZMOM5rEu7w6Kpr/XfylvL/WNet25
         GrEdzvln89WvlFmMwmav+jfTacKEEDb81pR/g=
Message-ID: <bc64b4640806190916g5d3c13aatce399348d8700f0d@mail.gmail.com>
Date: Thu, 19 Jun 2008 20:16:47 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "pHilipp Zabel" <philipp.zabel@gmail.com>
Subject: Re: [PATCH] MFD maintainer
Cc: ian <spyro@f2s.com>, "Samuel Ortiz" <sameo@openedhand.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ben Dooks" <ben-linux@fluff.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <74d0deb30806190910w558636cat21d1ffd4b0036f51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080618214223.GE22566@caravaggio>
	 <74d0deb30806190259l2ff7931fo819ededc7aec02f7@mail.gmail.com>
	 <1213872881.17281.32.camel@wirenth>
	 <bc64b4640806190412m70cbb15dr76a25ecb99c245dc@mail.gmail.com>
	 <1213888192.17281.45.camel@wirenth>
	 <74d0deb30806190910w558636cat21d1ffd4b0036f51@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/6/19 pHilipp Zabel <philipp.zabel@gmail.com>:
> On Thu, Jun 19, 2008 at 5:09 PM, ian <spyro@f2s.com> wrote:
>> On Thu, 2008-06-19 at 15:12 +0400, Dmitry wrote:
>>
>>> > I'll tidy up the code and pop a branch on my git server for people to
>>> > review, if thats what people want.
>>>
>>> It's better to send patches to some ML.
>>
>> Well, the code I had is updated to match linus -git branch
>> eseries_release7 if anyones curious. (no real changes since last time
>> though)
>>
>>> > Dmitry - if you have any pending patches now is the time to send them on
>>> > over ;-)
>>>
>>> Actually the code I'm using has diverged a bit from the last code I've
>>> sent before this merging pulse.
>>
>> All progress is good :)
>>
>>> As you have seen, I've tried to submit parts of the core and tmio-nand
>>> driver as a start.
>>
>> Has any of that got merged yet? If so, I'll adapt my strategy to match
>> that, otherwise I'll try to keep all the drivers in parallel.
>>
>>>  Then I'd suggest to merge other tmio core bits (support for tc6387xb
>>>  and t7l66xb). The MMC, usb and fb cell drivers could benefit from
>>>  clocklib patches I'm trying to get in.
>>
>> I'd like to see those. I'll get MMC and USB updated ASAP.
>
> That is interesting. I just asked Samuel about the ASIC3 MMC code
> which Aric copied from tc6393xb. It seems we should try to reuse the
> tmio driver itself for ASIC3?

That was also one of the goals for the tmio cell drivers. However merging
ASIC3 support will require some hacking around address shifts for the cell.

>
>> have you solved the clock-api-tied-to-platform-architecture problem ?
>>
>>>  I'll submit the updated version of mfd-core patch this evening,
>>
>> Looking forward to it.
>>
>>>  however some other bits will require  more time from my side.
>>
>> Lets rock :-)
>
> regards
> Philipp
>



-- 
With best wishes
Dmitry
