Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbYJITpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbYJITpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYJITp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:45:27 -0400
Received: from kara.rubysoft.com ([64.34.171.174]:52798 "EHLO
	kara.rubysoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbYJITp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:45:26 -0400
Date: Thu, 9 Oct 2008 13:45:20 -0600 (MDT)
From: Jeff Hansen <x@jeffhansen.com>
X-X-Sender: ninkid@ren
Reply-To: Jeff Hansen <x@jeffhansen.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Chris Snook <csnook@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <alpine.LFD.2.00.0810092118100.3271@apollo>
Message-ID: <Pine.LNX.4.64.0810091344250.24851@ren>
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com>
 <Pine.LNX.4.64.0810081342570.11108@ren> <48ED1728.5060708@redhat.com>
 <Pine.LNX.4.64.0810081542300.14815@ren> <48ED2A89.3000902@redhat.com>
 <Pine.LNX.4.64.0810081554380.14982@ren> <alpine.LFD.2.00.0810090910510.3237@apollo>
 <48EE4FC4.7070902@redhat.com> <alpine.LFD.2.00.0810092118100.3271@apollo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so are we all agreed that something like clocksource_trust=tsc 
would be the best?

-Jeff

---------------------------------------------------
"If someone's gotta do it, it might as well be me."

On Thu, 9 Oct 2008, Thomas Gleixner wrote:

> On Thu, 9 Oct 2008, Chris Snook wrote:
>>
>> Fair enough, but do you think it's worthwhile to have an option to disable
>> CLOCK_SOURCE_MUST_VERIFY checking for all timers, or should we implement this
>> on a case-by-case basis when there's legitimate cause, like with TSC?
>
> Case-by-case is preferred.
>
> Thanks,
>
> 	tglx
>
>
