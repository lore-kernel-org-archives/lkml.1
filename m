Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbXLTO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbXLTO4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762007AbXLTO4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:56:25 -0500
Received: from relay2.sgi.com ([192.48.171.30]:42719 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761507AbXLTO4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:56:21 -0500
Message-ID: <476A828F.2010706@sgi.com>
Date: Thu, 20 Dec 2007 06:56:15 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: not needed patch
References: <200712192057.02500.yinghai.lu@sun.com> <20071220142906.GA20794@elte.hu>
In-Reply-To: <20071220142906.GA20794@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> Ingo.
>>
>> commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9 is not needed. another 
>> patch (by you !! commit 699d934d5f958d7944d195c03c334f28cc0b3669 x86: 
>> fixup cpu_info array conversion) already removed clearing of 
>> c->cpu_index. in identify_cpu
>> also it is not consisent to smpboot_32.c. (it will assign id to 
>> cpu_index right after
>>
>>  	*c = boot_cpu_data;
>> )
> 
> well, it might in the worst-case be a superfluous change, but not cause 
> any problems in 2.6.24, right?
> 
>> by revert commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9, we could 
>> use c->cpu_index in identify_cpu.
> 
> but that's 2.6.25 stuff, right? Travis?

Since 6.5.24 needs to close soon, I'll queue up this change for 6.5.25.

Thanks everyone!

-Mike
