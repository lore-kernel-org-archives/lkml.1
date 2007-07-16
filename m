Return-Path: <linux-kernel-owner+w=401wt.eu-S1764967AbXGPOql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764967AbXGPOql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759759AbXGPOqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:46:33 -0400
Received: from fep07.mfe.bur.connect.com.au ([203.63.86.27]:45949 "EHLO
	fep07.mfe.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760152AbXGPOqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:46:32 -0400
Message-ID: <469B83FD.8080409@murdoch.edu.au>
Date: Mon, 16 Jul 2007 22:43:09 +0800
From: "Z. Cliffe Schreuders" <c.schreuders@murdoch.edu.au>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: Including STRTOK_R in a LSM
References: <214530.36096.qm@web36609.mail.mud.yahoo.com>
In-Reply-To: <214530.36096.qm@web36609.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- "Z. Cliffe Schreuders" <c.schreuders@murdoch.edu.au> wrote:
>
>   
>> What I need is to ignore double delimiters such as (::). This can be 
>> done trivially with a string comparison to check for "\0". What I want 
>> to know is if it is ok to include the strtok_r code in my security 
>> module, or if strtok was removed for a very good reason. I am porting a 
>> lot of existing code which already uses strtok_r to a kernel security 
>> module.
>>     
>
> All over the Linux world little red flags are popping up.
>
> Text processing of the sort that requires token parsing is rare
> in the kinds of things the kernel is usually called upon to do.
> You did mention, and someone else demonstrated, that there are
> existing alternatives that you could adopt. Cluttering the kernel
> with duplicate functionality is strongly discouraged.
>   
Thanks Casey,

I plan to pass simple lines of policy from user-space into kernel 
functions which use this information to build the internal 
representation of policy.
I had started writing these functions in user-space (to save time :\) 
and stupidly did not check that strtok_r was available from within the 
kernel (I thought string.h would include it). Anyway, so now I have a 
rewrite on my hands (unless I just include the strtok_r code). All part 
of the learning process I guess.
> As far as porting existing code into the kernel goes, be sure to
> have a look at the official coding style before you show what you've
> done to anyone. 
Will do.
> If you're porting "a lot" of code (Use SELinux as a
> benchmark for an LSM. If you're bigger than that you have "a lot"
> of code) you may also be putting too much into the kernel. 
It is not a lot in comparison to SELinux.

Thanks,

Cliffe.
