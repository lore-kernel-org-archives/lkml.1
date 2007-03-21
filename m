Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbXCUNLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbXCUNLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXCUNLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:11:53 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:3087 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXCUNLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:11:52 -0400
Message-ID: <46012E1A.3030309@sciensis.com>
Date: Wed, 21 Mar 2007 15:07:38 +0200
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
Cc: Francois Romieu <romieu@fr.zoreil.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel  
         version 2.6.20.1)
References: <45FEB8B7.7020200@sciensis.com>    <20070320004001.GA11601@electric-eye.fr.zoreil.com>    <000601c76af9$a0ce3ce0$0864a8c0@scs1>    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>    <000e01c76b99$769cbbe0$0864a8c0@scs1> <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>
In-Reply-To: <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, March 21, 2007 10:15, Tasos Parisinos wrote:
>   
>> Protecting a TripleDES key in high security standards is not as
>> simple as making the kernel read
>> protected, you need a whole lot and
>> that also means hardware (cryptomemories e.t.c)
>> So you forget about all this overhead when you use assymetric
>>     
>
> Ah, you're talking about fishing the key out of RAM here, right?
> My point stays the same for that: If you can't read protect the
> kernel RAM, small chance you can write protect it. And then they
> can just bypass all signature checking you put in it anyway.
>   

How can one tamper (write) the kernel memory of a booted and running kernel
without using an exploitable bug?

I mean, you can't mess with the bzImage on flash, the secure bootloader 
boots it without
letting someone alter the (non crypto-) memory while loading the bzImage 
on it, and then
no-one can run something that will tamper the system or write anywhere 
on kernel memory
without exploiting a bug

I mean, am i missing something here?


