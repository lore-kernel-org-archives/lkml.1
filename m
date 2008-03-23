Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbYCWXcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbYCWXcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 19:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbYCWXbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 19:31:52 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:44361 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbYCWXbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 19:31:51 -0400
Message-ID: <47E6E85E.9030008@frugalware.org>
Date: Mon, 24 Mar 2008 00:31:42 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com> <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org> <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de> <47E5221B.5040900@frugalware.org> <alpine.LFD.1.00.0803221730560.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803222113541.3781@apollo.tec.linutronix.de> <47E58B06.8020905@frugalware.org> <47E63851.7000702@frugalware.org>
In-Reply-To: <47E63851.7000702@frugalware.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Gabriel C wrote:
>> Thomas Gleixner wrote:
>>> On Sat, 22 Mar 2008, Thomas Gleixner wrote:
>>>> On Sat, 22 Mar 2008, Gabriel C wrote:
>>>>> With this one TSC is fine but now I get a warning on boot :
>>>> Good. It confirms my assumptions about the root cause.
>>>>
>>>>> [    0.041037] ------------[ cut here ]------------
>>>>> [    0.041052] WARNING: at arch/x86/kernel/smp_32.c:562 native_smp_call_function_mask+0x23/0x11e()
>>>> Grr. I'll work out a solution for that one.
>>> Gabriel,
>>>
>>> I'm happy to rack your nerves some more.
>> No worries :) 
>>
>>> After discussing the issue with Peter and Ingo the following solution
>>> seems to be the one which is the least intrusive. 
>>>
>>> Can you please give it a test ride ?
>> Done , git head + Andi's patch + this version of your patch does work here.
>>
>> Also time-warp-test is just fine and everything else seems to work.
> 
> Also I've tested with my other motherboard and is fine too :)
> 
> Feel free to add my Tested-by when you push this patch.

Heh :/

...

[ 5902.632878] Clocksource tsc unstable (delta = 4686687272 ns)
[ 5920.650516] Time: acpi_pm clocksource has been installed.

...

Seems like something still triggers that :/ 


