Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbXHOP26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbXHOP26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762008AbXHOP2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:28:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761834AbXHOP2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:28:48 -0400
Message-ID: <46C31B80.4040509@redhat.com>
Date: Wed, 15 Aug 2007 12:28:00 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 21/25][V3] export cpu_gdt_descr
References: <11871823373106-git-send-email-gcosta@redhat.com> <11871823673236-git-send-email-gcosta@redhat.com> <11871823782610-git-send-email-gcosta@redhat.com> <11871823892519-git-send-email-gcosta@redhat.com> <11871823991803-git-send-email-gcosta@redhat.com> <11871824081337-git-send-email-!gcosta@redhat.com> <11871824192375-git-send-email-gcosta@redhat.com> <11871824292046-git-send-email-gcosta@redhat.com> <20070815140339.GG3406@bingen.suse.de> <5d6222a80708150725i45a064bfqfd43139338287988@mail.gmail.com> <20070815154351.GI3406@bingen.suse.de>
In-Reply-To: <20070815154351.GI3406@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen escreveu:
> On Wed, Aug 15, 2007 at 11:25:43AM -0300, Glauber de Oliveira Costa wrote:
>> On 8/15/07, Andi Kleen <ak@suse.de> wrote:
>>>> +#ifdef CONFIG_PARAVIRT
>>>> +extern unsigned long *cpu_gdt_descr;
>>> No externs in .c files
>>>
>>> Normally they should be where the variable is defined
>>> anyways.
>> Given that this  variable is defined in head.S, what do you propose?
> 
> Move it to C code first.
> 

duh. I haven't noticed that this variable is already defined as extern 
in desc.h.

If you don't oppose, I'll just include it in x8664_ksyms.c

Thanks for the nitpicking, Andi.

