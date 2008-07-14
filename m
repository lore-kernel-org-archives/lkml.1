Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYGNQI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYGNQI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYGNQIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:08:50 -0400
Received: from il.qumranet.com ([212.179.150.194]:58592 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYGNQIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:08:49 -0400
Message-ID: <487B7A10.9050104@qumranet.com>
Date: Mon, 14 Jul 2008 19:08:48 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> We dont do any instruction decoding in #GP handlers to figure out what 
>> happened, while in the pagefault case we know which address faulted, 
>> etc.
>>     
>
> Why would we care? It would be very obvious from the instruction 
> disassembly plus the register contents. No need to decode instructions.
>   

We could add a printk to the #GP handler that alerts the reader that a 
poisoned list is suspected, if we find the address pattern in one of the 
registers.

-- 
error compiling committee.c: too many arguments to function

