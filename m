Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYCUPYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYCUPYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYCUPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:24:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:14204 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYCUPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:24:27 -0400
Message-ID: <47E3D322.1090902@googlemail.com>
Date: Fri, 21 Mar 2008 16:24:18 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Gabriel C <crazy@frugalware.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com>
In-Reply-To: <47DF3E8B.6040502@googlemail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Gabriel C wrote:
>> Thomas Gleixner wrote:
>>> On Mon, 17 Mar 2008, Gabriel C wrote:
>>>>> Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
>>>>> Submitter	: Gabriel C <nix.or.die@googlemail.com>
>>>>> Date		: 2008-02-24 01:31 (22 days old)
>>>>> References	: http://lkml.org/lkml/2008/2/23/380
>>>>> 		  http://lkml.org/lkml/2008/2/24/281
>>>>> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
>>>>>
>>>> Thomas do you want me to bisect ? 
>>> That'd be great.
>> Ok I'll start doing that later on today.
>>
> 
[ snip ]

> still hangs when I boot with clocksource=acpi_pm so that seems to be introduced in a different commit.
> 
> I will try to bisect this hang also , most probably on weekend.
> 

Correction on this one.

Current git head boots just fine with clocksource=acpi_pm here , I just don't know which commit fixed it.

Gabriel
