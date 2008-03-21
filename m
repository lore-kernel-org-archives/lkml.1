Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYCUQrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYCUQrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756575AbYCUQqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:46:49 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:58481 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbYCUQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:46:49 -0400
Message-ID: <47E3E66F.9040006@frugalware.org>
Date: Fri, 21 Mar 2008 17:46:39 +0100
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
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com> <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 21 Mar 2008, Gabriel C wrote:
>  
>>> still hangs when I boot with clocksource=acpi_pm so that seems to
>>> be introduced in a different commit.
>>>
>>> I will try to bisect this hang also , most probably on weekend.
>>>
>> Correction on this one.
>>
>> Current git head boots just fine with clocksource=acpi_pm here , I
>> just don't know which commit fixed it.
> 
> Hmm. Very dubious. I'm a bit afraid of self healing problems. It would
> be interesting to find the commit which fixed the acpi_pm timer
> problem unvoluntary.

I can try to find it.

> 
> Also, can you please reapply the reverted clocksource patch ? I have
> the feeling that the acpi_pm one was the real problem which was
> triggered the modfied watchdog.

Sure I can , will do so in some minutes and let you know.

> 
> Thanks,
> 
> 	tglx


Gabriel
