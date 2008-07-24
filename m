Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbYGXDRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbYGXDRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYGXDRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:17:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYGXDRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:17:13 -0400
Message-ID: <4887F33D.6020803@zytor.com>
Date: Wed, 23 Jul 2008 23:13:01 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, tglx@linutronix.de,
       andi@firstfloor.org, arjan@infradead.org, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console
References: <200807231252.20371.yhlu.kernel@gmail.com>	<20080723131218.f03ed672.akpm@linux-foundation.org> <m17ibcf0s8.fsf@frodo.ebiederm.org>
In-Reply-To: <m17ibcf0s8.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
>>> +static void dbgp_breath(void)
>>> +{
>>> +	/* Sleep to give the debug port a chance to breathe */
>>> +}
>> I expect the compiler will optimise away any calls to this.
> 
> It is documentation that is if it might be a good idea to not hit the
> hardware there.
> 

Sounds an awful lot like cpu_relax(); doesn't it?

	-hpa

