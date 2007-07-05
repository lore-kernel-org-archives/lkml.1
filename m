Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbXGILUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbXGILUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXGILTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:19:01 -0400
Received: from mail.tmr.com ([64.65.253.246]:34742 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756265AbXGILSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:18:55 -0400
Message-ID: <468D3FD6.7060607@tmr.com>
Date: Thu, 05 Jul 2007 15:00:38 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Tejun Heo <htejun@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com> <468AB1A7.9010201@msgid.tls.msk.ru> <468AF5BB.10005@gmail.com> <468B6BD7.9010108@msgid.tls.msk.ru> <Pine.LNX.4.64.0707040621170.32656@p34.internal.lan> <Pine.LNX.4.64.0707040631370.32656@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0707040631370.32656@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Wed, 4 Jul 2007, Justin Piszcz wrote:
> 
>> On Wed, 4 Jul 2007, Michael Tokarev wrote:
>>
>> > Tejun Heo wrote:
>> >> Hello,
>> >>
>> >> Michael Tokarev wrote:
>> >>> Well.  It looks like the results does not depend on the
>> >>> elevator.  Originally I tried with deadline, and just
>> >>> re-ran the test with noop (hence the long delay with
>> >>> the answer) - changing linux elevator changes almost
>> >>> nothing in the results - modulo some random "fluctuations".
>> >>
>> >> I see.  Thanks for testing.
>> >
>> > Here are actual results - the tests were still running when
>> > I replied yesterday.
>> >
>> > Again, this is Seagate ST3250620AS "desktop" drive, 7200RPM,
>> > 16Mb cache, 250Gb capacity.  The tests were performed with
>> > queue depth = 64 (on mptsas), drive write cache is turned
>> > off.
>>
>> I found AS scheduler to be the premium and best for single-user 
>> performance.
>>
>> You want speed? Use AS.
>>
>> http://home.comcast.net/~jpiszcz/sched/cfq_vs_as_vs_deadline_vs_noop.html
>>
>>
> 
> Does not include noop-- tested the main three though, renamed :)
> 
> http://home.comcast.net/~jpiszcz/sched/cfq_vs_as_vs_deadline.html
> 
> And for the archives:
> 
> p34-cfq,15696M,77114.3,99,311683,55.3333,184947,38.6667,79842.7,99,524065,41.3333,634.033,0.333333,16:100000:16/64,1043.33,8.33333,4419.33,11.6667,2942,17.3333,1178,10.3333,4192.67,12.3333,2619.33,19 
> 
> p34-as,15696M,76202.3,99,443103,85,189716,34.6667,79552,99,507271,39.6667,607.067,0,16:100000:16/64,1153,10,13434,36,2769.67,16.3333,1201.67,10.6667,3951.33,12,2665.67,19 
> 
> p34-deadline,15696M,76933.3,98.6667,386852,72,183016,29.6667,79530.7,99,512082,39.6667,678.567,0,16:100000:16/64,1230.33,10.3333,12349,32.3333,2945,17.3333,1258,11,8183,22.3333,2867,20.3333 
> 
I looked at these before, did you really run with a chunk size of just 
under 16GB, or does "15696M" have some inobvious meaning?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
