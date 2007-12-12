Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbXLLS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbXLLS2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXLLS2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:28:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXLLS2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:28:02 -0500
Message-ID: <476027F9.8020006@redhat.com>
Date: Wed, 12 Dec 2007 16:27:05 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 0/19] desc_struct integration
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <20071212172019.GA11258@elte.hu> <20071212181111.GA23306@elte.hu> <20071212182057.GA26515@elte.hu>
In-Reply-To: <20071212182057.GA26515@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>>> Ingo, in the absense of further complaints, could you please push 
>>>> to the x86 tree?
>>> yeah, i've added them.
>> the patches cause a spontaneous reboot on x86 64-bit, around the time 
>> when bootup hits user-space. It's due to one of the 25 patches from 
>> you today. Config attached.
> 
> likely caused by this patch:
> 
>   Subject: unify non-paravirt parts of desc.h
> 
> _please_ be more careful when unifying. Do check the before/after 
> vmlinux - the binary size at least. And watch out for compiler warnings 
> as well:
> 
>  arch/x86/kernel/process_64.c: In function 'read_32bit_tls':
>  arch/x86/kernel/process_64.c:454: warning: passing argument 1 of 'get_desc_base' from incompatible pointer type
I saw this warning, and this was fixed in the patch that follows. But 
yeah, I could have done a separate one, to avoid it. Do you have any 
other reason to believe this is the cause?

My box booted fine with the changes, but I'm re-verifying, and will send 
and update soon.

> i've pulled the patches from the tree for now.
Ok, I'll investigate it, meanwhile.

