Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbZGFIvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbZGFIvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZGFIv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:51:26 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:43048 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbZGFIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:51:25 -0400
Message-ID: <4A51BB0B.8000409@petalogix.com>
Date: Mon, 06 Jul 2009 10:51:23 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add checksum selftest
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org> 	<200906241724.30947.arnd@arndb.de> <8bd0f97a0906241243k1d4a6d25x3216e940b356d2ca@mail.gmail.com> 	<200906251255.06984.arnd@arndb.de> <4A51B204.4090501@petalogix.com> <8bd0f97a0907060124t7a2641b8k8fe28f78f70fd3cf@mail.gmail.com>
In-Reply-To: <8bd0f97a0907060124t7a2641b8k8fe28f78f70fd3cf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Mon, Jul 6, 2009 at 04:12, Michal Simek wrote:
>   
>> Arnd Bergmann wrote:
>>     
>>> On Wednesday 24 June 2009, Mike Frysinger wrote:
>>>       
>>>> ok, i can see that for the result, but how do i handle the functions
>>>> that also take a __wsum ?  do i just always pass them 0 to avoid
>>>> implementation issues ?
>>>>         
>>> No, any __wsum you pass in there should be fine, because that one
>>> gets folded in in the end.
>>>       
>> Mike do you have any updated patch? I would like to check it on
>> Microblaze too.
>>     
>
> the latest code i have is here:
> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=shortlog;h=asm-generic
>   
ok. Thanks.

> but i havent finished integrating the tests and i think they currently
> fail on Blackfin due to it
>   
On Microblaze all tests failed too.

Michal

> -mike
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

