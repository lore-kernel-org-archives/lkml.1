Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYC1IvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYC1IvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYC1IvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:51:00 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:34942 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbYC1Iu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:50:58 -0400
Date: Fri, 28 Mar 2008 09:50:45 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: =?UTF-8?Q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Rehbach <markus.rehbach@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <20080327235039.GA26291@atjola.homenet>
Message-ID: <alpine.DEB.1.10.0803280947410.19746@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org> <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de> <20080327235039.GA26291@atjola.homenet>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Björn Steinbrink wrote:
>> Subject: x86: fix prefetch workaround
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Thu Mar 27 15:58:28 CET 2008
>>
>> some early Athlon XP's and Opterons generate bogus faults on prefetch
>                    ^^
>
> Umh, XP? Didn't you say X2 above? And looking at the patch, X2 seems
> more plausible as well, I don't think that the XP supported the NX bit,
> did it?

Hm, would be a shame because I have an XP 2600+. /proc/cpuinfo tells me:

flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr mca cmov pat pse36 
mmx fxsr sse syscall mmxext 3dnowext 3dnow ts

...no NX in there. I wonder why this (already applied) patch should do 
anything on my box at all.

Thanks,
C.
-- 
BOFH excuse #216:

What office are you in? Oh, that one.  Did you know that your building was built over the universities first nuclear research site? And wow, aren't you the lucky one, your office is right over where the core is buried!
