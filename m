Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYJWP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYJWP5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYJWP5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:57:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:12336 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751953AbYJWP5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:57:34 -0400
Message-ID: <49009EDA.2030707@ru.mvista.com>
Date: Thu, 23 Oct 2008 19:57:14 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE updates #4
References: <200810212100.52985.bzolnier@gmail.com> <58cb370e0810220514x419c9669jba1b7be942d3644a@mail.gmail.com> <48FF2047.6000509@ru.mvista.com> <200810222337.42218.bzolnier@gmail.com> <48FFAFBB.8020709@ru.mvista.com>
In-Reply-To: <48FFAFBB.8020709@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>> and number of new submitted patches is < 10 (I'll take
>>>> care of fixing them up, ditto for all other new stuff that will be 
>>>> using old
>>>> naming scheme).

>>>    Thanks for clarifying this.
>>>    This rename only added more uncertainty for my pending patchset 
>>> (which had been already dependant on at least TX4939 driver which 
>>> keeps being recast by Atsushi and being stale in pata-2.6 series) as 
>>> I can't predict when you and Linus will merge the changes and this is 
>>> getting on my nerves, as I don't have time on any extra rework and 
>>> I'm running out of time with the submission. I know I should have 
>>> done this earlier and     

>> Maybe some parts could be submitted separately?
>> (so keeping them up-to-date in pata-2.6 would be my task)

>   2 (maybe even 3) out of 4 can be but that doesn't make much sense 
> already (and would incur the patch reordering for me) -- the best thing 
> you can do is to merge ASAP the last verison of TX4939 which has my ACK.
> I'm not sure about TX4938 driver yet -- will look at it after some sleep...

    Still haven't looked at it... too little sleep and incuring headache. :-/

>> Also I didn't know anything about your patchset and its
>> dependency on TX4939, otherwise I'll be pushing things in

>   The patchset consists of a large patch moving read_sff_dma_status() to 
> its porper place, one small preparatory patch, and 2 followup patches, 
> so unfortunately it's dependent on TX4939 in its main patch (worse, the 
> relevant part of this driver has changed after your last merged driver 
> version)...

>> different order or even skip this pull request if needed
>> (TX493x drivers are new stuff and were still under review,
>> such things can be also submitted after the merge window
>> closes so they were given the lowest priority).

>   Unfortunately, that driver has been submitted first back 9/09, long 
> before my patchset was even created, so the dependence was just natural.

    I could also rip out TX4939 part from the patch and leave Atsushi to deal 
with the fallout (though I could give him the ripped out part to simply be 
merged to the driver) if you would queue my patchset ahead of the driver. 
Though I feel it's too late now for my patchset to get into 2.6.28 the way 
things have been happening... :-/

MBR, Sergei

