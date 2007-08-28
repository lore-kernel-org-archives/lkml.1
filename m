Return-Path: <linux-kernel-owner+w=401wt.eu-S1764249AbXH1Tbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764249AbXH1Tbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762411AbXH1TRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:17:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64319 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762152AbXH1TRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:17:16 -0400
Message-ID: <46D4748A.4070909@oracle.com>
Date: Tue, 28 Aug 2007 12:16:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Michael Evans <mjevans1983@gmail.com>
CC: Bill Davidsen <davidsen@tmr.com>,
       "Michael J. Evans" <mjevans1983@comcast.net>,
       Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
References: <200708222058.45480.mjevans1983@comcast.net>	 <20070827153020.43788e21.randy.dunlap@oracle.com>	 <200708272138.19785.mjevans1983@comcast.net>	 <46D3A8AD.6000701@oracle.com>	 <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>	 <46D421F6.50205@tmr.com>	 <4877c76c0708280632t3eb40d01od1267c8c4a7d8de@mail.gmail.com>	 <46D44A09.5060901@oracle.com>	 <4877c76c0708281010x4597a9cfpc252dc4ee2a0ef9e@mail.gmail.com>	 <46D459C9.9050709@oracle.com> <4877c76c0708281211s55aded4ajceb283da25223659@mail.gmail.com>
In-Reply-To: <4877c76c0708281211s55aded4ajceb283da25223659@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Evans wrote:
> On 8/28/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> Michael Evans wrote:
>>> On 8/28/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>> Michael Evans wrote:
>>>>> On 8/28/07, Bill Davidsen <davidsen@tmr.com> wrote:
>>>>>> Michael Evans wrote:
>>>>>>> Oh, I see.  I forgot about the changelogs.  I'd send out version 5
>>>>>>> now, but I'm not sure what kernel version to make the patch against.
>>>>>>> 2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
>>>>>>> Additionally I never could tell what git tree was the 'mainline' as it
>>>>>>> isn't labeled with such a keyword (at least in the list of git trees I
>>>>>>> saw).
>>>>>> I suspect you wait for 2.5.23 release, or send it to AKPM for inclusion
>>>>>> in an "-mm" kernel. That's probably desirable, anyway.
> 
> Gentoo's mm-sources is version 2.6.23-rc3-mm1, which I'd guess is
> close enough for an area like this.  Given that I didn't need to make
> any changes to the patch should I just submit it to the mm for testing
> without rebooting in to an mm-sources kernel?  I need to schedule when
> I do that so it would take me overnight to do so.

Yes, I think that you can go ahead with that, but it's up to the
subsystem maintainers where/when it goes from there.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
