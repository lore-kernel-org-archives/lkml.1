Return-Path: <linux-kernel-owner+w=401wt.eu-S969178AbXG3WWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969178AbXG3WWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939577AbXG3WWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:22:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:50452 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbXG3WWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NU8rFrvtTl55KuJczYlo+f0DbLf4dkfHjbsMl7e91feG7u8McYEgVuP5ZwgZ71/uCJAWMDx3ii7K2S1xG4JXu8GqWNjVZ942PuWZwjZ/yL9D4mUzfRdmuHH0LEGb0LgaoHu9xZbGvKEZlkrTSS1ImbSsf8H2qO/h7Lt1QHGBbQc=
Message-ID: <46AE6372.20808@googlemail.com>
Date: Tue, 31 Jul 2007 00:17:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sasa Ostrouska <casaxa@gmail.com>
CC: Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: forcedeth ?
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>	 <46AE6029.60308@googlemail.com> <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
In-Reply-To: <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sasa Ostrouska wrote:
> On 7/31/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>> Sasa Ostrouska wrote:
>>> On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
>>>> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
>>>>> Hi people,
>>>>>
>>>>> I'm using this on a x86-64 amd machine. During boot of the last
>>>>> 2.6.22.1 kernel I get this error:
>>>> Somewhat unrelated, but I had a similar forcedeth problem, I took the
>>>> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
>>>>
>>>> Good luck!
>>>> --
>>>> avuton
>>> Ok, maybe I can try that. In any case I noticed another strange thing.
>>> I have 2 nics in that machine.
>>> One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
>>> RTL8029 using the
>>> ne2k_pci.
>>> Now, whenever I compile them both as modules each reboot the cards get
>>> inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
>>> the next boot it is eth1 , this is very anoying as one cant make only
>>> one boot, probably this is someway related to the bios.
>>> Now I configured them one in the kernel and the other as a module so
>>> they get each time assigned the same name. But when powerloss happens
>>> (unplug the cable) the next boot they do not work. I see them assigned
>>> the correct name, ifconfig shows the IP's but ping results in a
>>> destination unreachable.
>>>
>>> Any ideas ?
>> Udev rules ?
>>
>>
> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
> to check that, thx for the tip.

Yes udev does this based on the MAC address but AFAIK forcedeth is 'special' for some reason 
( which I can really remember now and gets on each boot a new MAC address or alike )

You could try to make your rules based on the pci bus id instead of the MAC address. ( at least I think this should work )

> Rgds
> Sasa
> 

Gabriel
