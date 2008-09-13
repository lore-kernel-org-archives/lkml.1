Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYIMA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYIMA3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbYIMA3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:29:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:64281 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbYIMA3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:29:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,392,1217833200"; 
   d="scan'208";a="615773686"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>
CC: Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Date: Fri, 12 Sep 2008 17:26:47 -0700
Subject: RE: AGP PAT issue.
Thread-Topic: AGP PAT issue.
Thread-Index: AckT6E2Imurhin3yRVyx9N2ky75S3wBTuV/w
Message-ID: <7E82351C108FA840AB1866AC776AEC462CA8E8B7@orsmsx505.amr.corp.intel.com>
References: <20080820194127.GA10887@linux-os.sc.intel.com>
 <48AC8F69.4050201@keyaccess.nl>
 <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com>
 <20080820221630.GA3598@linux-os.sc.intel.com>
 <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl>
 <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu>
 <48AF1B6A.80408@keyaccess.nl> <48C8259B.7040702@keyaccess.nl>
 <20080911081702.GA27425@elte.hu> <48C8D731.4000309@keyaccess.nl>
In-Reply-To: <48C8D731.4000309@keyaccess.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Rene Herman [mailto:rene.herman@keyaccess.nl]
>Sent: Thursday, September 11, 2008 1:31 AM
>To: Ingo Molnar
>Cc: Pallipadi, Venkatesh; Dave Airlie; Li, Shaohua; Yinghai
>Lu; Andreas Herrmann; Arjan van de Ven; Linux Kernel; Siddha,
>Suresh B; Thomas Gleixner; H. Peter Anvin; Dave Jones
>Subject: Re: AGP PAT issue.
>
>On 11-09-08 10:17, Ingo Molnar wrote:
>
>> * Rene Herman <rene.herman@keyaccess.nl> wrote:
>>
>>> On 22-08-08 22:02, Rene Herman wrote:
>>>
>>>> On 22-08-08 06:15, Ingo Molnar wrote:
>>>>> The frontside cache itself is in x86/urgent:
>>>>>
>>>>>  # 80c5e73: x86: fix Xorg startup/shutdown slowdown with PAT
>>>>>
>>>>> ... and should at least solve the symptom that you've hit
>in practice
>>>>> (the slowdown), without changing the underlying PAT
>machinery. (which
>>>>> would be way too dangerous for v2.6.27)
>>>> Well, please note that that specific commit only fixes X
>startup -- it
>>>> doesn't do anything for shutdown. With only that one, I'm
>still at 14
>>>> seconds for X shutdown (first time after boot that is, 5 seconds
>>>> subsequent shutdowns) versus 1 (or sub 1, feels immediate)
>normally.
>>>>
>>>> It's also a black-screen "hang", so we'll probably be
>getting a lot of
>>>> "long hang at shutdown" reports without something
>additionally for .27.
>>>>
>>>> Venki?
>>> Haven't been subcribed to any lists recently and someone was talking
>>> about "the other thread" before but just noticed that an
>-rc6 was cut.
>>>
>>> Please note that the shutdown issue remains unfixed in it (I'm doing
>>> my coalescing changes locally).
>>
>> here's what is pending in tip/x86/pat for v2.6.28:
>
>Only talking about .27 and just making sure again the issue is known.
>
>The above mentioned subject for the entry cache one ("fix Xorg
>startup/shutdown slowdown with PAT") after all mistakingly says it does
>something for shutdown.
>

Can you try the patch here
http://www.ussg.iu.edu/hypermail/linux/kernel/0809.1/2074.html

That should resolve both reserve and free issues..

Thanks,
Venki
