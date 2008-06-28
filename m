Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbYF1BsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbYF1BsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 21:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYF1BsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 21:48:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYF1BsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 21:48:02 -0400
Message-ID: <486596BE.8090407@redhat.com>
Date: Fri, 27 Jun 2008 22:41:18 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 08/39] don't use word-size specifiers
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com> <1214602486-17080-2-git-send-email-gcosta@redhat.com> <1214602486-17080-3-git-send-email-gcosta@redhat.com> <1214602486-17080-4-git-send-email-gcosta@redhat.com> <1214602486-17080-5-git-send-email-gcosta@redhat.com> <1214602486-17080-6-git-send-email-gcosta@redhat.com> <1214602486-17080-7-git-send-email-gcosta@redhat.com> <1214602486-17080-8-git-send-email-gcosta@redhat.com> <1214602486-17080-9-git-send-email-gcosta@redhat.com> <48657524.4020307@kernel.org> <48657636.8070208@kernel.org>
In-Reply-To: <48657636.8070208@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> H. Peter Anvin wrote:
>>
>> I hate to say it, but I really think this is a step backwards in 
>> readability.  Consistency is a good thing, and with the suffixes in 
>> place we are consistent between instructions that refer to memory and 
>> instructions that refer to registers.  We also get one more check on 
>> things, where the assembler can tell the programmer he probably typoed.
>>
>> So I would prefer if we *didn't* go down this route, except for 
>> explicit unification, but that's not the case here (since the size is 
>> still explicit in the register names.)
>>
> 
> Okay, I didn't really explain what I meant very well here...
> 
> Obviously, most of your patch series is all about unification, and that 
> is a Good Thing, and thank you for doing it.  What I was trying to say 
> was that it is not obvious from just reading the patchset what changes 
> are necessary for unification, and which one are a stylistic change.  If 
> *all* the changes are unification, please just say so and disregard this 
> remark, and I'll go ahead and apply your patchset.
> 
>     -hpa
They're all about unification, but I split it for bisectability, as ingo 
many times requested (and it happened for me to agree completely with it
after a while ;-)).

So, exactly because not using size specifiers can introduce bugs here, I 
did it in a separate patch. But it all end at unification in the end.

Sorry if the intention was not explicit enough.
