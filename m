Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbYLKXCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbYLKXCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759649AbYLKXBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:01:23 -0500
Received: from mx01.qsc.de ([213.148.129.14]:55326 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759289AbYLKXBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:01:21 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 18:01:21 EST
Message-ID: <49419A14.50402@wizards.de>
Date: Thu, 11 Dec 2008 23:54:12 +0100
From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?= <holger@wizards.de>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de> <20081208222246.GA29232@sith.mimuw.edu.pl> <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com> <493FFE5E.2000404@colorfullife.com>
In-Reply-To: <493FFE5E.2000404@colorfullife.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear all -

Thanks for your efforts.

Manfred Spraul wrote:
> Chuck Ebbert wrote:
>> On Mon, 8 Dec 2008 23:22:46 +0100
>> Jan Rekorajski <baggins@sith.mimuw.edu.pl> wrote:
>>
>>  
>>> On Mon, 08 Dec 2008, Stefan Richter wrote:
>>>
>>>    
>>>>>>> On Monday, 8 of December 2008, Holger Hoffstaette wrote:
>>>>>>>            
>>>>>>>> The system is a generic old single-core P4 box with a single
>>>>>>>> SATA drive,
>>>>>>>> Gentoo userland and Samba is 3.0.33 (in async mode). The kernel
>>>>>>>> has no
>>>>>>>> patches or binary drivers.
>>>>>>>>               
>>>> Holger, it may be unrelated to the issue, but to be sure:  Which
>>>> network
>>>> card driver do you use?
>>>>       
>>> I think you can safely rule out NIC, I'm also seeing this behaviour on a
>>> brand new server with imap hanging in some busy-loop.
>>> Network card in my case:
>>> Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
>>>
>>> What I observer was one CPU doing 100% system work, and the number of
>>> timer interrupts went from 1k per second to 4k (for the whole system).
>>>
> Could you try the attached patch?
> It should fix the bug.

I just built 2.6.27.9-rc1 and disconnected the Windowz box several times.
For now smbd does not seem to go into a death spin any more, even though
as far as I can tell .9-rc1 does not contain Manfred'd latest patch. Not
sure what that means, if anything.

I'll keep running stable.9-rc1 and see what happens..

thanks all
Holger

