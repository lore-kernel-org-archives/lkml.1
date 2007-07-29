Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXG2Nrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXG2Nrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762292AbXG2Nrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:47:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:35053 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831AbXG2Nrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:47:47 -0400
Message-ID: <46AC9A8D.8060003@qumranet.com>
Date: Sun, 29 Jul 2007 16:47:57 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1, KVM-AMD problem
References: <200707281855.41277.alistair@devzero.co.uk> <200707291229.49155.alistair@devzero.co.uk> <46AC7B44.1040509@qumranet.com> <200707291444.18024.alistair@devzero.co.uk>
In-Reply-To: <200707291444.18024.alistair@devzero.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Sunday 29 July 2007 12:34:28 you wrote:
> [snip]
>   
>>> Doesn't help, I still get the same crashes. I tried 2.6.22 again and it's
>>> rock solid by comparison.
>>>       
>> Do you mean, kvm-33 on top of 2.6.22, or the kvm modules from 2.6.22?
>> Please describe your configuration *exactly*.
>>     
>
> I'm using the kvm-33 *userspace* package (based on Debian's kvm-28 packaging) 
> and 2.6.23-rc1's KVM modules. I patched 2.6.23-rc1 with the patch you 
> provided in your last email. So I'm not using -git HEAD.
>
> Maybe there's been additional necessary fixes to -git requiring me to update 
> to HEAD? That wasn't clear from your last email.
>   

No,  that patch is the only potential fix post -rc1.  There are a few 
other fixes there, but they are intended to avoid guest crashes, not 
host crashes.

What guest are you running?  Maybe I can reproduce it here.

-- 
error compiling committee.c: too many arguments to function

