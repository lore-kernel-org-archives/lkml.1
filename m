Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZKHQfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZKHQfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZKHQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:35:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZKHQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:35:22 -0500
Message-ID: <4AF6F323.5000005@zytor.com>
Date: Sun, 08 Nov 2009 08:34:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
References: <1257233486.22553.6.camel@wall-e>	 <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e>	 <1257409189.26874.18.camel@wall-e> <20091108113546.GN11372@elte.hu>	 <1257684666.20579.9.camel@wall-e>  <20091108125527.GA19350@elte.hu> <1257688828.23062.0.camel@wall-e>
In-Reply-To: <1257688828.23062.0.camel@wall-e>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2009 06:00 AM, Stefani Seibold wrote:
> Am Sonntag, den 08.11.2009, 13:55 +0100 schrieb Ingo Molnar:
>> * Stefani Seibold <stefani@seibold.net> wrote:
>>
>>>> I'd suggest a competely different method: why dont you use an IPI to 
>>>> sample the SP whenever someone wants to read it from /proc and we 
>>>> see that the task is running on a CPU right now?
>>>
>>> Sounds like a challenge, i like the idea. I will have a look on it...
>>
>> It's not a fastpath, so smp_function_call() ought to do the trick.
> 
> There is no function smp_function_call()...
> 

smp_call_function().

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

