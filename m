Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYGNG0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYGNG0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYGNG0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:26:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38658 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYGNG0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:26:05 -0400
Date: Mon, 14 Jul 2008 08:26:44 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.26-rc7: Negative powertop values
Message-ID: <20080714062644.GE31949@elf.ucw.cz>
References: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com> <20080621141615.51f7100c@linux.intel.com> <20080706194845.GA5617@ucw.cz> <20080708065251.1d7d681f@linux.intel.com> <20080713115818.GA7517@elf.ucw.cz> <487A20DF.7060701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487A20DF.7060701@linux.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-07-13 08:35:59, Arjan van de Ven wrote:
> Pavel Machek wrote:
>> On Tue 2008-07-08 06:52:51, Arjan van de Ven wrote:
>>> On Sun, 6 Jul 2008 21:48:45 +0200
>>> Pavel Machek <pavel@suse.cz> wrote:
>>>
>>>>> [I assume you know that doing a software unplug you burn more power
>>>>> than by leaving the cpu idle]
>>>> We should really fix that one day...
>>> yeah but it's incredibly hard to get right (in the light of the bios
>>> constantly changing what our allowed C-states are)... and the best case
>>
>> What can happen there? So BIOS decides C4 may no longer be cool idea
>> because we have AC power now, but that does not mean C4 stops working,
>> right?
>
> or it decides that your voltage regulator needs to operate in a certain mode and the voltage for C4 is no longer
> available. or .. or ...
>
>>
>> How is changing allowed C-states list supposed to work, anyway? I
>> mean, we may be in one of those on other CPU when BIOS decides to
>> change the list...
>
> you get an interrupt to notify you of the change ;-)

But that's too late, right? You may be actively using that Cstate on
another CPU...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
