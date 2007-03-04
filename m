Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXCDXdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXCDXdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXCDXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:33:11 -0500
Received: from hot.fatooh.org ([63.99.9.127]:55277 "EHLO hot.fatooh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXCDXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:33:10 -0500
Message-ID: <45EB5733.9080604@fatooh.org>
Date: Sun, 04 Mar 2007 15:33:07 -0800
From: Corey Hickey <bugfood-ml@fatooh.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT -> crash under load in 2.6.20?
References: <87d53qxbzi.fsf@hades.wkstn.nix> <45EB1C44.1000702@fatooh.org> <871wk41uiq.fsf@hades.wkstn.nix>
In-Reply-To: <871wk41uiq.fsf@hades.wkstn.nix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nix wrote:
>>> I can't tell if magic sysrq dies, because as far as I know there's no
>>> way to get magic sysrq to do much visible when you're in X, and I can't
>>> get anything to go over the network kernel syslog because the network is
>>> dead.
>> You should still be able to use SysRQ even in X. I tested right now.
>> 1. Have X running already and then start X in another VT
>>    $ X :2 vt10
>> 2. Hit Alt+SysRQ+K
>>    ---> X dies, display gets corrupted, and keyboard input ignored
>> 3. ssh in from another machine and switch back to the running X instance
>>    # chvt 7
> 
> The network's dead; that's impossible.

I'm sorry, you misunderstand: I meant the above steps as a method of
confirming that SysRQ normally still works while X is running, not as
anything useful to do after your system has hung.

Now that I re-read what you wrote initially, however, I think I somewhat
misunderstood what you wrote anyway, and you probably already knew that
SyrRQ worked in X.

Anyway...

>  22:58:47 up 10 days, 22:20, 37 users,  load average: 12.71, 11.14, 18.22
> 
> No problems, and I've been loading the system really rather hard today
> (as that line makes clear). I think the problem I'm seeing really *is*
> tied to _PREEMPT.

Yeah, that's pretty indicative. As for me, I just tried disabling
CONFIG_CC_OPTIMIZE_FOR_SIZE; so far so good, but I don't even have 4
hours uptime yet. We'll see.

>> It might be helpful if you reported your hardware information; I'd be
>> interested in seeing if there's much in common with my own machine.
> 
> Athlon 4 (UP), 768Mb RAM. No ACPI (to rule out a large nasty spot as
> soon as possible). Random info starting with loaded modules:

[info cut]

Nothing really in common with mine. Oh well.

-Corey
