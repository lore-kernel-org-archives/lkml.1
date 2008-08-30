Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYH3GY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYH3GY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYH3GYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:24:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbYH3GYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:24:46 -0400
Date: Fri, 29 Aug 2008 23:21:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Witbrodt <dawitbro@sbcglobal.net>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <724017.46804.qm@web82108.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0808292318300.3290@nehalem.linux-foundation.org>
References: <724017.46804.qm@web82108.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, David Witbrodt wrote:
> 
> Not sure if you wanted ME to test this, but I've been watching this
> argument with Yinghai and became curious...

You'll eventually have something to test, this part was just 
infrastructure and didn't change anything at all.

> I updated my git tree so that I have the insert_resource_expand_to_fit()
> changes, and the kernel builds fine.  Unfortunately, it hangs like all
> 2.6.2[67] kernels without reverting 3def3d6d... and 1e934dda... (or
> without the later patches provided by Ingo and Yinghai).
> 
> Sorry if I am interfering... just wanted to inject this data, in case
> it's meaningful!

Yeah, nothing has changed yet for your case. What should change your case 
is the thing Yinghai is working on with the "late add of e820 data to the 
resource tree".

His earlier version already worked for you, didn't it? We're really now 
just finalizing details (in fact, "insert_resource_expand_to_fit()" is 
just a helper function for a detail that may not even matter all that 
much).

		Linus
