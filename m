Return-Path: <linux-kernel-owner+w=401wt.eu-S939993AbXHIPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939993AbXHIPLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933898AbXHIPLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:11:07 -0400
Received: from gw.goop.org ([64.81.55.164]:56401 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763466AbXHIPLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:11:06 -0400
Message-ID: <46BB2E1C.2060100@goop.org>
Date: Thu, 09 Aug 2007 08:09:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081200.13669.ak@suse.de> <46BAB9DD.5030400@goop.org> <200708091626.09316.ak@suse.de> <Pine.LNX.4.58.0708091032300.32067@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0708091032300.32067@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> --
> On Thu, 9 Aug 2007, Andi Kleen wrote:
>   
>>> This has to match the normal C calling convention though, doesn't it?
>>>       
>> Native cli/sti/save/restore_flags are all only assembly and can be easily
>> (in fact more easily than in C) written as pure assembler functions. Then
>> you can use whatever calling convention you want.
>>     
>
> I agree.
> Should we make a paravirt_ops_asm.S file that can implement these native
> funcions, and so we can get rid of the C functions only doing asm?
>
>   
>> While some paravirt implementations may have more complicated implementations
>> i guess it's still a reasonable requirement to make them simple enough
>> in pure assembler. If not they can use a trampoline, but that's hopefully
>> not needed.
>>     
>
> It works for lguest64.  I'm sure it should be no problem with other HVs.
>   

Hm, I can't say the idea thrills me.  Lets get the thing working first,
and then worry about having special per-pvop calling conventions.

    J
