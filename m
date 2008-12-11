Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYLKK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYLKK0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYLKKZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:25:59 -0500
Received: from smtp1.nine.ch ([217.150.241.29]:44739 "EHLO smtp1.nine.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbYLKKZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:25:58 -0500
Message-ID: <4940EA97.8020308@miromico.ch>
Date: Thu, 11 Dec 2008 11:25:27 +0100
From: Alex Raimondi <mailinglist@miromico.ch>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: kernel@avr32linux.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Segfault in fbcmap.c => Compiler bug?
References: <4940CE1F.5080605@miromico.ch> <20081211092959.6410c352@hcegtvedt> <4940D8C0.9060709@miromico.ch>
In-Reply-To: <4940D8C0.9060709@miromico.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for the records: 

Removing the atmel precompiled toolchain and switching over to buildroot toolchain (same gcc version) 
completely solved the problem.

Alex
> 
>> On Thu, 11 Dec 2008 09:23:59 +0100
>> Alex Raimondi <mailinglist@miromico.ch> wrote:
>>
>> Hi Alex,
>>
>>> I am using latest atmel avr32 kernel (2.6.27) form
>>> git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git.
>>> I am on it's master branch. I added a few patches specific to our own
>>> board (hammerhead). 
>>>
>> Which toolchain are you using? If you have grabbed it from atmel.com
>> you have to download Buildroot for AVR32 [1] and build your own
>> toolchain. The toolchain on atmel.com is broken.
> 
> I have both. AV32 toolchain from atmel is installed via apt-get. I have builroot 2.2.1 which 
> generated a toolchain, as well. 
> 
> but kernel compilation is done using apt-get toolchain.
> 
> So, your suggestion is to remove the atmel stuff completely and use only buildroot toolchain?
> 
> Thx, 
> 
> Alex
> 
>>> When compiling with support for atmel_lcdfb the kernel segfaults at
>>> module probe.
>>>
>>> This is the segfault output:
>>>
>>> **********************************
>>> alg: No test for stdrng (krng)
>>> io scheduler noop registered
>>> io scheduler cfq registered (default)
>>> atmel_lcdfb atmel_lcdfb.0: 225KiB frame buffer at 13940000 (mapped at
>>> b3940000) Unable to handle kernel NULL pointer dereference at virtual
>> Does indeed look like a known GCC bug.
>>
>> <snipp> rest of kernel dump and debugging>
>>
>> 1: www.atmel.no/buildroot
>>
> 
> _______________________________________________
> Kernel mailing list
> Kernel@avr32linux.org
> http://duppen.flaskehals.net/cgi-bin/mailman/listinfo/kernel

