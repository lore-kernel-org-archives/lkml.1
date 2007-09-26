Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbXIZA4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbXIZA4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbXIZAz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:55:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48829 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756903AbXIZAzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:55:55 -0400
Date: Wed, 26 Sep 2007 02:55:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <david@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
       Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070926005551.GS6800@stusta.de>
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46F99EDE.70905@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 09:20:54AM +0930, David Newall wrote:
> Alan Cox wrote:
>> On Wed, 26 Sep 2007 01:05:07 +0930
>> David Newall <david@davidnewall.com> wrote:
>>> Alan Cox wrote:
>>>     
>>>>> Marek's loading dynamic libraries, it seems clear that the prime 
>>>>> purpose of chroot is to aid security.  Being able to cd your way out is 
>>>>> handy             
>>>> Does it - I can't find any evidence for that.
>>>>       
>>> It seems self-evident to me.  What do you think is it prime purpose?
>>>     
>>
>> Debugging and testing. At least that is as I understand it much of where
>> it came from.
>>   
>
> Good call.  Though I suppose, since it's used 24x7 to aid security on 
> countless production servers, that security dwarfs testing.  Still, 
> debugging, yes that's valid.

Incompetent people implementing security solutions are a real problem.

> I don't suppose it makes and difference; whatever the purpose, a chroot 
> that doesn't change the root is buggy.

It does change the root.

But it does not limit what the root user can do after the root was 
changed.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

