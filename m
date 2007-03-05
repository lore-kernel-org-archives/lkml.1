Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbXCEQQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbXCEQQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXCEQQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:16:45 -0500
Received: from mail.tmr.com ([64.65.253.246]:58336 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbXCEQQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:16:44 -0500
Message-ID: <45EC4200.5050109@tmr.com>
Date: Mon, 05 Mar 2007 11:14:56 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <20070305075747.GA19838@elte.hu>
In-Reply-To: <20070305075747.GA19838@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Adrian Bunk <bunk@stusta.de> wrote:
> 
>> Subject    : i386: no boot with nmi_watchdog=1  (clockevents)
>> References : http://lkml.org/lkml/2007/2/21/208
>> Submitter  : Daniel Walker <dwalker@mvista.com>
>> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>>              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
>> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>> Status     : problem is being debugged
> 
> FYI, this is not a "wont boot" problem, this should be a "NMI watchdog 
> does not work" problem - which has far lower severity. Also, Thomas did 
> a fix for this which is now in -mm.
> 
If a system normally runs a watchdog, and some do, then nmi would be 
forced on by grub.comf and the system would not boot. And if the system 
was counting on nmi to look for a hanging problem, "nmi does not work" 
would be a real problem if the failure was silent.

Actually, a lack of nmi would be worse than not booting, it would be a 
time bomb waiting for a bad moment to hang.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
