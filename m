Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbYJVW5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbYJVW5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYJVW5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:57:08 -0400
Received: from h155.mvista.com ([63.81.120.155]:54013 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751963AbYJVW5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:57:07 -0400
Message-ID: <48FFAFBB.8020709@ru.mvista.com>
Date: Thu, 23 Oct 2008 02:56:59 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE updates #4
References: <200810212100.52985.bzolnier@gmail.com> <58cb370e0810220514x419c9669jba1b7be942d3644a@mail.gmail.com> <48FF2047.6000509@ru.mvista.com> <200810222337.42218.bzolnier@gmail.com>
In-Reply-To: <200810222337.42218.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>> and number of new submitted patches is < 10 (I'll take
>>> care of fixing them up, ditto for all other new stuff that will be using old
>>> naming scheme).
>>>   
>>>       
>>    Thanks for clarifying this.
>>    This rename only added more uncertainty for my pending patchset 
>> (which had been already dependant on at least TX4939 driver which keeps 
>> being recast by Atsushi and being stale in pata-2.6 series) as I can't 
>> predict when you and Linus will merge the changes and this is getting on 
>> my nerves, as I don't have time on any extra rework and I'm running out 
>> of time with the submission. I know I should have done this earlier and 
>>     
>
> Maybe some parts could be submitted separately?
> (so keeping them up-to-date in pata-2.6 would be my task)
>   

   2 (maybe even 3) out of 4 can be but that doesn't make much sense 
already (and would incur the patch reordering for me) -- the best thing 
you can do is to merge ASAP the last verison of TX4939 which has my ACK. 
I'm not sure about TX4938 driver yet -- will look at it after some sleep...

> Also I didn't know anything about your patchset and its
> dependency on TX4939, otherwise I'll be pushing things in
>   

   The patchset consists of a large patch moving read_sff_dma_status() 
to its porper place, one small preparatory patch, and 2 followup 
patches, so unfortunately it's dependent on TX4939 in its main patch 
(worse, the relevant part of this driver has changed after your last 
merged driver version)...

> different order or even skip this pull request if needed
> (TX493x drivers are new stuff and were still under review,
> such things can be also submitted after the merge window
> closes so they were given the lowest priority).
>   

   Unfortunately, that driver has been submitted first back 9/09, long 
before my patchset was even created, so the dependence was just natural.

> Please ping me about such issues, I'm certainly willing to
> adjust my workflow if this is going to help other people with
> their work but I can't do much if I don't know anything...
>   

   I probably should've followed up to your first mail expressing the 
intent to remove the subdirs in 2.6.28 but haven't... anyway, it's hard 
to predict how the things would go (unless you always expect them to go 
the worst possible way -- that expectation seems to never fail :-).

>> I'd have done this if its not for my unfortunate vacations... I aslso 
>> kept finding new issues looking on the IOC4 driver. :-/
>>     

  Though I only was looking at it because of the TX4939 driver being 
outdated in pata-2.6 series... otherwise I'd have spent my time on the 
patchset in question. BTW, the reviews I've been doing have also been 
time consuming... and that's not speaking of the MUSB issues I've been 
trying to deal with at the same time at work. :-)

> I remember about your SGIIOC4 fixes and they are going to
> make the next git pull request so sooner this one gets in the
> better.  Also maybe you could get some help with fixing this
> driver from SGI folks if there are still some issues left?
>   

   Frankly speaking, I don't see much SGI's interest in this driver (e. 
g., I bet they could've implemented DMA tuning having the docs but never 
done that). I've just fixed what my sight fell at (there are 3 pending 
cleanup patches but those will have to wait now).

   To continue my whining, the bad news of the past day were that I 
discovered that my pet Geode board stopped to come up, and that hard 
drive plugged into HPT371N chip on my other pet Alchemy board didn't get 
detected by the recent kernel -- and that's not due to my patches (which 
I was sanity-testing on this board). When I plugged the drive into 
Promise IDE card (PDC20269), it got detected alright. I don't know what 
that means yet -- need to try Rocket100 (HPT370) card yet...

> Thanks,
> Bart
>   

MBR, Sergei


