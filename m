Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbXH1RXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbXH1RXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbXH1RXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:23:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10780 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbXH1RXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:23:03 -0400
Message-ID: <46D459C9.9050709@oracle.com>
Date: Tue, 28 Aug 2007 10:22:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Michael Evans <mjevans1983@gmail.com>
CC: Bill Davidsen <davidsen@tmr.com>,
       "Michael J. Evans" <mjevans1983@comcast.net>,
       Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
References: <200708222058.45480.mjevans1983@comcast.net>	 <200708271516.21889.mjevans1983@comcast.net>	 <20070827153020.43788e21.randy.dunlap@oracle.com>	 <200708272138.19785.mjevans1983@comcast.net>	 <46D3A8AD.6000701@oracle.com>	 <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>	 <46D421F6.50205@tmr.com>	 <4877c76c0708280632t3eb40d01od1267c8c4a7d8de@mail.gmail.com>	 <46D44A09.5060901@oracle.com> <4877c76c0708281010x4597a9cfpc252dc4ee2a0ef9e@mail.gmail.com>
In-Reply-To: <4877c76c0708281010x4597a9cfpc252dc4ee2a0ef9e@mail.gmail.com>
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
>>> On 8/28/07, Bill Davidsen <davidsen@tmr.com> wrote:
>>>> Michael Evans wrote:
>>>>> Oh, I see.  I forgot about the changelogs.  I'd send out version 5
>>>>> now, but I'm not sure what kernel version to make the patch against.
>>>>> 2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
>>>>> Additionally I never could tell what git tree was the 'mainline' as it
>>>>> isn't labeled with such a keyword (at least in the list of git trees I
>>>>> saw).
>>>> I suspect you wait for 2.5.23 release, or send it to AKPM for inclusion
>>>> in an "-mm" kernel. That's probably desirable, anyway.
>>>>
>>>> --
>>> There's another list I should CC to?  Or does the section maintainer
>>> do that when they're happy with the patch?
>> Not another list; just cc: akpm@linux-foundation.org so that he can merge
>> it into the -mm kernel patches for testing.  Most patches cook in the -mm
>> kernel(s) before they are merged into mainline.
>>
>> Then generally the subsystem maintainer(s) are responsible for sending
>> patches on to Linus for merging into mainline, if/when they are happy
>> with the patch and they think that it has been tested enough.
>>
> 
> So I should look at the git documentation again, try to pull down
> Andrew's latest -mm, and see what I need to change (if anything) to
> patch against it?  (I would probably only verify that boots once my
> self given the other testing this has already seen and how often mm
> breaks things my mythtv box likes, such as nvidia-drivers, etc,)

-mm is available only as a patchset, not via git.
There has been a git version of it, but it's not currently working and
hasn't been for 2 months or so.

I mostly use the grab_kernel script that I mentioned.  It knows how
to download linux-2.6.M and how to apply -rcN, -gitN, and/or -mmN
patches to the base (linux-2.6.M).

E.g.:
grab_kernel 2.6.23-rc3-git6 $PWD
or
grab_kernel 2.6.23-rc3-mm1 $PWD


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
