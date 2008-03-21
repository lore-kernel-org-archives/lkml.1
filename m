Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbYCUT7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbYCUT7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYCUT7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:59:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbYCUT7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:59:37 -0400
Message-ID: <47E4137C.3010203@zytor.com>
Date: Fri, 21 Mar 2008 12:58:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
References: <200803202358.33722.yhlu.kernel@gmail.com>	 <20080321120313.GD25225@elte.hu> <47E3B335.3020501@zytor.com> <86802c440803211208v40088eb1qe3f03977b220078@mail.gmail.com>
In-Reply-To: <86802c440803211208v40088eb1qe3f03977b220078@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Mar 21, 2008 at 6:08 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Ingo Molnar wrote:
>>  >
>>  > very nice patch! I always thought that this was the proper way to do
>>  > memtest - and we could in fact also do something like this after SMP
>>  > bringup, and hit the memory bus via multiple CPUs. [that will need a
>>  > different enumeration though than e820 maps]
>>  >
>>  > one structural observation: please make this unified functionality, so
>>  > that 32-bit kernels can make use of it too.
>>  >
>>
>>  Indeed.  Of course, it would also be nice if distros shipped
>>  bootloader-invoked prekernel test software, like memtest86+, by default.
> 
> the current memtest86 is running in 32 bit mode, and only support 64G ram.
> 
> I tried to expand that a bit, to support 1024g, but it only works on
> some machine.
> could be stack provide is not big enough?
> 

Wonder how hard it would be to make it run 64 bits...

	-hpa
