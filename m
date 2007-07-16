Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbXGPJ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbXGPJ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXGPJ3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:29:01 -0400
Received: from il.qumranet.com ([82.166.9.18]:39849 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXGPJ3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:29:00 -0400
Message-ID: <469B3A63.50206@qumranet.com>
Date: Mon, 16 Jul 2007 12:29:07 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL][RESEND] KVM Updates for 2.6.23-rc1
References: <11843929041758-git-send-email-avi@qumranet.com> <alpine.LFD.0.999.0707151641560.20061@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707151641560.20061@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sat, 14 Jul 2007, Avi Kivity wrote:
>   
>> Linus, please do your usual thing from the repository and branch at
>>     
>
> It has code like
>
> 	+       /* Can deadlock when called with interrupts disabled */
> 	+       WARN_ON(irqs_disabled());
> 	+
> 	        /* prevent preemption and reschedule on another processor */
> 	        int me = get_cpu();
>
> which is against the coding conventions (and shouldn't even compile 
> cleanly - but maybe we don't have the "warn about C99 variable 
> declarations" thng on?).
>   

It's on.  I guess I didn't notice because other changes triggered a 
recompile of the whole tree.

> Please don't do that.
>   

Fixed and rebased.  I also silenced a few warnings on the UP case by 
adding a missing #include.  It's at the same place:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

-- 
error compiling committee.c: too many arguments to function

