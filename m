Return-Path: <linux-kernel-owner+w=401wt.eu-S1161216AbXCNMTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161216AbXCNMTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161206AbXCNMTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:19:47 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:42470 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161201AbXCNMTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:19:46 -0400
Message-ID: <45F7E7B1.3030600@gmail.com>
Date: Wed, 14 Mar 2007 13:16:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Florian Lohoff <flo@rfc822.org>
Subject: Re: [6/6] 2.6.21-rc3: known regressions
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125025.GW18731@stusta.de> <1173818777.13341.128.camel@localhost.localdomain> <20070314114417.GB18731@stusta.de>
In-Reply-To: <20070314114417.GB18731@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 14 Mar 2007 13:16:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk napsal(a):
> On Tue, Mar 13, 2007 at 09:46:17PM +0100, Thomas Gleixner wrote:
>> On Tue, 2007-03-13 at 13:50 +0100, Adrian Bunk wrote:
>>> This email lists some known regressions in Linus' tree compared to 2.6.20.
>>>
>>> If you find your name in the Cc header, you are either submitter of one
>>> of the bugs, maintainer of an affectected subsystem or driver, a patch
>>> of you caused a breakage or I'm considering you in any other way
>>> possibly involved with one or more of these issues.
>>>
>>> Due to the huge amount of recipients, please trim the Cc when answering.
>>> Subject    : Clocksource tsc unstable (delta = -154983451 ns)
>>> References : http://lkml.org/lkml/2007/3/9/271
>>> Submitter  : Jiri Slaby <jirislaby@gmail.com>
>>> Status     : unknown
>> That's not a regression. That's an informal message, when the TSC
>> watchdog detects that the TSC is unreliable. 
> 
> Looking at [1], there's also be a probably related "doesn't boot" 
> problem.
> My first guess would be commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
> "clocksource init adjustments (fix bug #7426)".
> 
> Jiri, is the message also present with 2.6.21-rc2 (at a different place 
> of the dmesg) for you?

Yes, it's present there too, some lines below the place, where it is placed 
in -rc3.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
