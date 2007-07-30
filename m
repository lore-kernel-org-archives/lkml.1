Return-Path: <linux-kernel-owner+w=401wt.eu-S969561AbXG3WZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969561AbXG3WZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968927AbXG3WZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:25:01 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:32996
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968917AbXG3WZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:25:00 -0400
Date: Mon, 30 Jul 2007 15:24:05 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Sasa Ostrouska <casaxa@gmail.com>, Gabriel C <nix.or.die@googlemail.com>,
       Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: forcedeth ?
In-Reply-To: <3ae72650707301522r4241353ld1be5dd7a2322233@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707301522340.12232@asgard.lang.hm>
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com> 
 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com> 
 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com> 
 <46AE6029.60308@googlemail.com>  <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
 <3ae72650707301522r4241353ld1be5dd7a2322233@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, Kay Sievers wrote:

> On 7/31/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
>> On 7/31/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>>> Sasa Ostrouska wrote:
>>>> On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
>>>>> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
>>>>>> Hi people,
>>>>>>
>>>>>> I'm using this on a x86-64 amd machine. During boot of the last
>>>>>> 2.6.22.1 kernel I get this error:
>>>>> Somewhat unrelated, but I had a similar forcedeth problem, I took the
>>>>> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
>>>>>
>>>>> Good luck!
>>>>> --
>>>>> avuton
>>>>
>>>> Ok, maybe I can try that. In any case I noticed another strange thing.
>>>> I have 2 nics in that machine.
>>>> One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
>>>> RTL8029 using the
>>>> ne2k_pci.
>>>> Now, whenever I compile them both as modules each reboot the cards get
>>>> inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
>>>> the next boot it is eth1 , this is very anoying as one cant make only
>>>> one boot, probably this is someway related to the bios.
>>>> Now I configured them one in the kernel and the other as a module so
>>>> they get each time assigned the same name. But when powerloss happens
>>>> (unplug the cable) the next boot they do not work. I see them assigned
>>>> the correct name, ifconfig shows the IP's but ping results in a
>>>> destination unreachable.
>>>>
>>>> Any ideas ?
>>>
>>> Udev rules ?
>>>
>> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
>> to check that, thx for the tip.
>
> Udev does that already, it automatically creates rules and assigns
> persistent names to newly discovered network hardware. The names will
> be stable across reboots, regardless of module loading order or
> anything else. But sure, that's only on distros who take these issues
> serious. :)

what do I need to do to disable this 'feature' having a box with 
interfaces eth0, eth9, eth10 becouse the box once had a couple of quad 
cards in it is annoying.

David Lang
