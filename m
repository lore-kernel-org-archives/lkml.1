Return-Path: <linux-kernel-owner+w=401wt.eu-S1030630AbXCLQiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030630AbXCLQiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030632AbXCLQiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:38:24 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:33180 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030630AbXCLQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:38:23 -0400
Date: Mon, 12 Mar 2007 12:38:04 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-reply-to: <8cd998d50703120458j6ac9f33h79728f2f599a3b91@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "Radoslaw Szkodzinski" <astralstorm@gmail.com>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
Message-id: <200703121238.04191.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
 <200703120749.39303.gene.heskett@gmail.com>
 <8cd998d50703120458j6ac9f33h79728f2f599a3b91@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007, Con Kolivas wrote:
>On 12/03/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Monday 12 March 2007, Gene Heskett wrote:
>> >To Con, I knew 2.6.20 worked with your earlier patches, so rather
>> > than revert all the way, I just rebooted to 2.6.20.2-rdsl-0.30 and
>> > I'm going to fire off another backup.  I suspect it will work, but
>> > will advise the next time I wake up.
>>
>> After posting the above, I thought maybe I'd hit a target in the
>> middle and build a 2.6.20.2, with your -0.30 patch, but...
>>
>> I'm going to have to build a 2.6.20.2, because with the rdsl-0.30
>> patch, its going to do a level 2 on my /usr/movies directory, which
>> hasn't been touched in 90 days and has about 8.1GB in it according to
>> du, and its going to do nearly all of it.  It shouldn't be anything
>> but a directory listing file. But this is what amstatus is reporting:
>> coyote:/usr/movies            2     7271m dumping      793m ( 10.91%)
>> (7:26:00)
>>
>> And its also reporting far more data than exists it seems. As is du,
>> for /var, which might have 2 gigs, its claiming 3.7!
>>
>> Honest folks, I'm not smoking anything, I quit 18 years ago.  Back to
>> bed while this one bombs out too.
>>
>> --
>> Cheers, Gene
>
>Gene your last good kernel you said was 2.6.20 based. I don't see a
>good reason even to use 2.6.20.2 as a base given that information.
>
I have 2.6.20.1 building now.  I know that 2.6.20-ck1 worked well, so now 
I walking fwd from 2.6.20, trying to bisect it.  .1 wasn't much of a 
patch, but who knows at this point, I'm not 'the shadow' in a 65 year old 
radio show.  And it looks like that build is done, so here goes the next 
test.

The worst thing about this is that amanda's database is being hosed 
everytime this happens, and it's been 3 runs in a row, in a dumpcycle of 
5, where this has occurred.  I can do one more bad run by pre-clearing 
the vtape +1 that's it is going to use each time because the partition 
being used for vtapes is sitting at about 93% utilization now.  Normal 
life, its about 84%, it is a 175GB partition.  That also is stirring 
around in the old girls database when I kill stuff she thinks is there, 
but its also about 3 dumpcycles back and pretty much out of the picture 
so she will recover in a couple of dumpcycles once I find this, if indeed 
I do.

You've cooked up patches for all this, so it 2.6.20.1 works ok, then I try 
your patch on that one.  I tried 2.6.21-rc1, and it bombed too, but I 
just figured that was an -rc1, and we're expected to lose a pint of blood 
at most any -rc1 aren't we?, so I didn't give it any great thought and 
reverted till -rc2 came out.  But I ramble & times-a-wasting.
>--
>-ck

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Research is to see what everybody else has seen, and think what nobody
else has thought.
