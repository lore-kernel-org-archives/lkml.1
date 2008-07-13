Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYGMPhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYGMPhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYGMPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:37:26 -0400
Received: from mga05.intel.com ([192.55.52.89]:19784 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973AbYGMPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:37:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,354,1212390000"; 
   d="scan'208";a="359095300"
Message-ID: <487A212E.1080505@linux.intel.com>
Date: Sun, 13 Jul 2008 08:37:18 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.26-rc7: Negative powertop values
References: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com> <20080621141615.51f7100c@linux.intel.com> <20080706194845.GA5617@ucw.cz> <20080708065251.1d7d681f@linux.intel.com> <20080713115818.GA7517@elf.ucw.cz>
In-Reply-To: <20080713115818.GA7517@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2008-07-08 06:52:51, Arjan van de Ven wrote:
>> On Sun, 6 Jul 2008 21:48:45 +0200
>> Pavel Machek <pavel@suse.cz> wrote:
>>
>>>> [I assume you know that doing a software unplug you burn more power
>>>> than by leaving the cpu idle]
>>> We should really fix that one day...
>> yeah but it's incredibly hard to get right (in the light of the bios
>> constantly changing what our allowed C-states are)... and the best case
> 
> What can happen there? So BIOS decides C4 may no longer be cool idea
> because we have AC power now, but that does not mean C4 stops working,
> right?

it's also the other way around; you put the sleepy core in C4 because C6 is not available;
then C6 becomes available and the sleepy core is wasting power;

Either way, the *best* case you get is to be equal to being idle.....

