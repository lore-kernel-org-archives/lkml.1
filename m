Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYE0VGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYE0VGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbYE0VGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:06:37 -0400
Received: from gw.goop.org ([64.81.55.164]:33479 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028AbYE0VGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:06:36 -0400
Message-ID: <483C77BA.7030900@goop.org>
Date: Tue, 27 May 2008 22:06:02 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805180118.57863.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com> <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de> <483C70F9.2030901@goop.org> <alpine.LFD.1.10.0805272256240.21533@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805272256240.21533@apollo.tec.linutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 27 May 2008, Jeremy Fitzhardinge wrote:
>   
>> Thomas Gleixner wrote:
>>     
>>> On Sun, 25 May 2008, Yinghai Lu wrote:
>>>   
>>>       
>>>> remove extra -1 in reseve_early calling
>>>>     panic if can not find space for new RAMDISK
>>>>
>>>>     
>>>>         
>>> Thanks, applied on top of the v2 update
>>>
>>> 	tglx
>>>   
>>>       
>> This patch is still required to make Xen boot with the e820 changes:
>>     
>
> Ok. This one was not in the queue you sent ?
>   

It wasn't, partly because I wasn't sure of the state of the e820 patches.

> Will pick it up.
>   

Thanks.

    J
