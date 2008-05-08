Return-Path: <linux-kernel-owner+w=401wt.eu-S1762274AbYEHKwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274AbYEHKwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYEHKwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:52:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58984 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYEHKwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:52:33 -0400
Message-ID: <4822DB6E.9040504@firstfloor.org>
Date: Thu, 08 May 2008 12:52:30 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mirco Tischler <mt-ml@gmx.de>, Ingo Molnar <mingo@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
References: <1210183536.28099.10.camel@mtlp.tischlernetz>  <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de>  <1210188734.5456.14.camel@mtlp.tischlernetz>  <alpine.LFD.1.10.0805072253480.3318@apollo.tec.linutronix.de> <1210196777.26103.8.camel@mtlp.tischlernetz> <48222742.5040008@firstfloor.org> <alpine.LFD.1.10.0805081207050.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805081207050.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 8 May 2008, Andi Kleen wrote:
>>> May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000
>>> May  7 21:52:04 kernel: [4294896.091827] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>>> May  7 21:52:04 kernel: [4294896.091827] Back to C!
>>> May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000
>> If the data is read correctly (and it looks like it) then just the bit
>> is wrong and we should ignore it I guess. So just remove the
>> WARN_ON_ONCE()?
> 
> You put a printk there in the first place :) I changed it to
> WARN_ON_ONCE as one line printks are more likely to be ignored.

Ignoring would have been fine here, but point taken.

> I'm all for it to remove the while BCD check, which is hardcoded to
> ALWAYS_BCD = 1 since linux 1.0.

Fine for me.

-Andi

