Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZAWSwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZAWSwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZAWSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:52:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:8391 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZAWSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=s2NbceiKiNJH0BYXo4XBm0N1P1dzHeZ/dqfVcV4a2x9uiQ+KCnIt8KY3FbaJVbsajL
         sA1htsSX/Wt/HTQbv6ZrtJdI22E3dRUT0/vAftOqpwRGfuEdZnAdgwU2DUx74w9FdnCC
         RBe1MSB58pHJj9o9xNxiZZi1N2ifK5yrP8YYA=
Message-ID: <497A11F5.9090005@gmail.com>
Date: Fri, 23 Jan 2009 20:52:37 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>
Subject: Re: inline asm semantics: output constraint width smaller than input
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com> <20090123183019.GA5984@elte.hu>
In-Reply-To: <20090123183019.GA5984@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-23 20:30, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> Having said that, llvm-gcc is not yet able to compile the full Linux 
>> kernel on its own [for example the boot code, due to asm(".code16gcc")], 
>> but with LLVM 2.4 it was possible to build "arch=UM", and "arch=X86" (by 
>> using gcc to build the bootcode). I'd like LLVM 2.5 to be able to build 
>> the kernel, so I'll file bugs for llvm/kernel depending on where the 
>> problem is.
>>     
>
> Could we get LLVM folks on the Cc: and see how difficult it would be to 
> fix this on the LLVM side? Asm constraints are used all around the place 
> and different input/output types are very common.

I've added LLVMDev to Cc.
Your first post to the list may take a little longer to reach it (first
post is moderated by listmaster, no subscription required).

[For those who missed the initial conversation, see:
http://llvm.org/bugs/show_bug.cgi?id=3373#c9]

Best regards,
--Edwin
