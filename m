Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXEROvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXEROvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXEROvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:51:14 -0400
Received: from h155.mvista.com ([63.81.120.155]:31502 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754315AbXEROvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:51:13 -0400
Message-ID: <464DBDBA.3060801@ru.mvista.com>
Date: Fri, 18 May 2007 18:52:42 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
Cc: galak@kernel.crashing.org, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <787b0d920705172024g723412b4n8f82d3cd78e0f702@mail.gmail.com>
In-Reply-To: <787b0d920705172024g723412b4n8f82d3cd78e0f702@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Albert Cahalan wrote:

>>>>> I haven't looked at all the new clock/timer code, is there any
>>>>> utility in having support for more than one clock source?

>>>> Of course, you may register as many as you like.

>>> Sure, but is there any utility in registering more than the
>>> decrementer on PPC?

>> Not yet. I'm not sure I know any other PPC CPU facility fitting
>> for clockevents. In theory, FIT could be used -- but its period
>> is measured in powers of 2, IIRC.

> I'd really like to have that as an option. It would allow oprofile
> to safely use hardware events on the MPC74xx "G4" processors.
> Alternately it would allow thermal events. It is safe to use at
> most one of the three (decrementer,profiling,thermal) interrupts.
> If two were to hit at the same time, badness happens.

    Unfortunately, FIT exists only on Book E CPUs and MPC74xx aren't Book E, IIUC.

> It's possible to wrapper the interrupt in something that divides
> down, calling the normal code only some of the time. I think one
> of the FIT choices is about 4 kHz on my system, which would be OK.

    Erm, are you sure you have FIT (or is your system not MPC74xx based)?

> Full oprofile functionality would be wonderful.

WBR, Sergei
