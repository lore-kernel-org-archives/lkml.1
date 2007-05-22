Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbXEVG4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbXEVG4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbXEVGz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:55:57 -0400
Received: from dedi.luli.de ([88.198.62.74]:47110 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480AbXEVGz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:55:56 -0400
Message-ID: <465293FA.1040909@rootdir.de>
Date: Tue, 22 May 2007 08:55:54 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Artur Kedzierski <artur@kedzierski.org>
CC: linux-kernel@vger.kernel.org, haveaniceday@cv-sv.de
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
References: <Pine.LNX.4.64.0705191820100.11197@merry.kedzierski.org>
In-Reply-To: <Pine.LNX.4.64.0705191820100.11197@merry.kedzierski.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Artur,
>     I purchased C7 VIA Esther and I experience similar problem with
> random crashes. There is also a thread on Via Arena about "J7F4K - 
> Hard Lockups" where people describe the same issue:
> http://forums.viaarena.com/messageview.aspx?catid=28&threadid=77032
>     I've tried the following kernels:
> 2.6.21.1 - crashes pretty quick
> 2.6.21.1 with disabled CPU scaling - better mileage but still crashes
> 2.6.22-rc1 - hangs on boot
> 2.6.22-rc1-mm1 - doesn't compile
> 2.6.22-rc2 - hangs on boot
here, too: crashes over crashes...
>     I've ran memtest86 and no memory problems were found.
>     Any ideas or suggestions?
>     Thank You.
The same here.


I applied the patch mentioned by Christian Volkmann in the thread "Re: 
2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II"  on May 
19th 2007. Since then I did not have a crash any more. Touch wood!

Could anyone explain to me what CMPXCHG64 / cx8 is and what happens if 
the kernel has been compiled to use it but the CPU does not have it? 
Especially if the CPU like the C7 supports it, but it's disabled? Would 
random crashes be a plausible effect?


Regards,
claas
