Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYGYQTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYGYQTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYGYQSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:18:23 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47858 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbYGYQSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:18:21 -0400
Message-ID: <4889FCCC.1010708@lwfinger.net>
Date: Fri, 25 Jul 2008 11:18:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: Kernel BUG in 2.6.26-git series
References: <4889E538.5010007@lwfinger.net> <19f34abd0807250803y2992aff8g369ce7f6b802708@mail.gmail.com>
In-Reply-To: <19f34abd0807250803y2992aff8g369ce7f6b802708@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, Jul 25, 2008 at 4:37 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> In the current git pulls from Linus's tree, I get a kernel BUG if
>> CONFIG_SCHED_SMT is defined. It does not always appear, but when it does, it
>> is late in the bootup sequence. Perhaps there is a timing issue. This is an
>> x86_64 system on an HP dv2815nr notebook with and AMD Turion X2 CPU. My
>> distro is openSUSE 11.0.
>>
>> kernel: BUG: unable to handle kernel NULL pointer dereference at
>> 000000000000002
>> kernel: IP: [<ffffffff80231aec>] sched_mc_power_savings_store+0x13/0x41
> 
> Maybe LKML is slow and somebody else replied to this before me, but I
> know how much I hate to discover that I've been bisecting something
> that was fixed a week ago in another tree, so here's a link you might
> try :-)

That patch fixes my problem as well. I scanned the LKML archive just before 
submitting my E-mail, but I missed your thread.

Thanks,

Larry
