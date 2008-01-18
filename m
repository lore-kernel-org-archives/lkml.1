Return-Path: <linux-kernel-owner+w=401wt.eu-S1765454AbYARTIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765454AbYARTIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbYARTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:08:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50144 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYARTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:08:33 -0500
Message-ID: <4790F7BF.2070304@zytor.com>
Date: Fri, 18 Jan 2008 14:02:23 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] x86: Use v8086_mode helper, trivial unification
References: <1200615957.5724.75.camel@brick>	 <20080118091208.GE24337@elte.hu>  <20080118150040.GB31446@elte.hu> <1200683074.5724.137.camel@brick>
In-Reply-To: <1200683074.5724.137.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Fri, 2008-01-18 at 16:00 +0100, Ingo Molnar wrote:
>>>> +	/*
>>>> +	 * Did it hit the DOS screen memory VA from vm86 mode?
>>>> +	 */
>>>> +	if (v8086_mode(regs)) {
>>>> +		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
>>>> +		if (bit < 32)
>>>> +			tsk->thread.screen_bitmap |= 1 << bit;
>>>> +	}
>> this does not build on 64-bit, because screen_bitmap is 32-bit only - so 
>> i had to pull the patch. I suspect a small #ifdef section would look 
>> better here?
>>
> 
> My original patch had the ifdef, you can grab that one.
> 

Me bad, I should have been less definite in my reply.

	-hpa
