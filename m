Return-Path: <linux-kernel-owner+w=401wt.eu-S1751264AbZH1BdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbZH1BdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZH1BdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:33:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZH1BdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:33:20 -0400
Message-ID: <4A9733C1.2070904@redhat.com>
Date: Thu, 27 Aug 2009 21:32:49 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz>
In-Reply-To: <20090827221319.GA1601@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 06:13 PM, Pavel Machek wrote:
>
>>>> Repeat experiment until you get up to something like google scale or the
>>>> other papers on failures in national labs in the US and then we can have an
>>>> informed discussion.
>>>>
>>> On google scale anvil lightning can fry your machine out of a clear sky.
>>>
>>> However, there are still a few non-enterprise users out there, and knowing
>>> that specific usage patterns don't behave like they expect might be useful to
>>> them.
>>
>> You are missing the broader point of both papers. They (and people like
>> me when back at EMC) look at large numbers of machines and try to fix
>> what actually breaks when run in the real world and causes data loss.
>> The motherboards, S-ATA controllers, disk types are the same class of
>> parts that I have in my desktop box today.
> ...
>> These errors happen extremely commonly and are what RAID deals with well.
>>
>> What does not happen commonly is that during the RAID rebuild (kicked
>> off only after a drive is kicked out), you push the power button or have
>> a second failure (power outage).
>>
>> We will have more users loose data if they decide to use ext2 instead of
>> ext3 and use only single disk storage.
>
> So your argument basically is
>
> 'our abs brakes are broken, but lets not tell anyone; our car is still
> safer than a horse'.
>
> and
>
> 'while we know our abs brakes are broken, they are not major factor in
> accidents, so lets not tell anyone'.
>
> Sorry, but I'd expect slightly higher moral standards. If we can
> document it in a way that's non-scary, and does not push people to
> single disks (horses), please go ahead; but you have to mention that
> md raid breaks journalling assumptions (our abs brakes really are
> broken).
> 								Pavel
>


You continue to ignore the technical facts that everyone (both MD and ext3) 
people put in front of you.

If you have a specific bug in MD code, please propose a patch.

Ric

