Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbXG2Le0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbXG2Le0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 07:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761543AbXG2LeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 07:34:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:34425 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761471AbXG2LeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 07:34:18 -0400
Message-ID: <46AC7B44.1040509@qumranet.com>
Date: Sun, 29 Jul 2007 14:34:28 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1, KVM-AMD problem
References: <200707281855.41277.alistair@devzero.co.uk> <46AC4CEB.9060401@qumranet.com> <200707291229.49155.alistair@devzero.co.uk>
In-Reply-To: <200707291229.49155.alistair@devzero.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Sunday 29 July 2007 09:16:43 Avi Kivity wrote:
>   
>> Alistair John Strachan wrote:
>>     
>>> Hi,
>>>
>>> I'm getting periodic oopses running KVM-33 on 2.6.23-rc1. Here is a
>>> digital photo of the oops. Alarmingly, a lot of the time it triple faults
>>> the machine and I don't get a chance to grab it. This time I was lucky,
>>> though.
>>>
>>> http://devzero.co.uk/~alistair/kvm-2.6.23-rc1.jpg
>>>
>>> Unfortunately, some of the oops text scrolled out of the screen. I will
>>> endeavour to reproduce the bug over serial console, but I can make no
>>> guarantees.
>>>
>>> The CPU is an AMD X2 BE-2350, chipset is AMD 690G.
>>>       
>> If you are using the modules from 2.6.23-rc1, try upgrading to latest
>> -git, which contains a patch that might fix this problem.  If you are
>> using the modules from kvm-33, try applying the attached patch.
>>     
>
> Doesn't help, I still get the same crashes. I tried 2.6.22 again and it's rock 
> solid by comparison.
>
>   

Do you mean, kvm-33 on top of 2.6.22, or the kvm modules from 2.6.22?  
Please describe your configuration *exactly*.

And what do you mean, "rock solid by comparison"?  Either it's rock 
solid or it isn't.

-- 
error compiling committee.c: too many arguments to function

