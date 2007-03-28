Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbXC1Xnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbXC1Xnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXC1Xnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:43:32 -0400
Received: from mail.tmr.com ([64.65.253.246]:52023 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834AbXC1Xnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:43:31 -0400
Message-ID: <460AFD89.30902@tmr.com>
Date: Wed, 28 Mar 2007 19:43:05 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Willy Tarreau <w@1wt.eu>, Xavier Bestel <xavier.bestel@free.fr>,
       Mark Lord <lkml@rtr.ca>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org> <1174125534.7734.2.camel@Homer.simpson.net> <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04> <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org> <20070320061152.GW943@1wt.eu> <Pine.LNX.4.64.0703200821420.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703200821420.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 20 Mar 2007, Willy Tarreau wrote:
>> Linus, you're unfair with Con. He initially was on this position, and lately
>> worked with Mike by proposing changes to try to improve his X responsiveness.
> 
> I was not actually so much speaking about Con, as about a lot of the 
> tone in general here. And yes, it's not been entirely black and white. I 
> was very happy to see the "try this patch" email from Al Boldi - not 
> because I think that patch per se was necessarily the right fix (I have no 
> idea), but simply because I think that's the kind of mindset we need to 
> have.
> 
> Not a lot of people really *like* the old scheduler, but it's been tweaked 
> over the years to try to avoid some nasty behaviour. I'm really hoping 
> that RSDL would be a lot better (and by all accounts it has the potential 
> for that), but I think it's totally naïve to expect that it won't need 
> some tweaking too.
> 
> So I'll happily still merge RSDL right after 2.6.21 (and it won't even be 
> a config option - if we want to make it good, we need to make sure 
> *everybody* tests it), but what I want to see is that "can do" spirit wrt 
> tweaking for issues that come up.
> 
May I suggest that if you want proper testing that it not only should be 
a config option but a boot time option as well? Otherwise people will be 
comparing an old scheduler with an RSDL kernel, and they will diverge as 
time goes on.

More people would be willing to reboot and test on a similar load than 
will keep two versions of the kernel around. And if you get people 
testing RSDL against a vendor kernel which might be hacked, it will be 
even less meaningful.

Please consider the benefits of making RSDL the default scheduler, and 
leaving people with the old scheduler with an otherwise identical kernel 
as a fair and meaningful comparison.

There, that's a technical argument ;-)

> Because let's face it - nothing is ever perfect. Even a really nice 
> conceptual idea always ends up hitting the "but in real life, things are 
> ugly and complex, and we've depended on behaviour X in the past and can't 
> change it, so we need some tweaking for problem Y".
> 
> And everything is totally fixable - at least as long as people are willing 
> to!
> 
> 		Linus


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

