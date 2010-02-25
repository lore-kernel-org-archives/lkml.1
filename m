Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0BYB4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:56:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35799 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab0BYB4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wKHf43o4MYFdg+jCslCrvlNooKibfoO6siZaCjG0PrgTpYtWXqnfYj/coj0FkO2t6V
         /ZoEjkwjOGqeL4+c2FFYKPIeU86xeWyoD27wsOV7ka916S6uAKJPnfjaDtR3FWxVEkgl
         ATLakd9D4bAlKOkOe5sl4Yhpf9GGueuAREIOE=
MIME-Version: 1.0
In-Reply-To: <1267050119.24271.7820.camel@gandalf.stny.rr.com>
References: <201002242107.o1OL7F6v020376@imap1.linux-foundation.org>
	 <20100224213406.GA7491@nowhere>
	 <1267050119.24271.7820.camel@gandalf.stny.rr.com>
Date: Thu, 25 Feb 2010 09:56:36 +0800
Message-ID: <a8e1da1002241756x6aa1a2fcqfb42d0fdd6962418@mail.gmail.com>
Subject: Re: + kernelh-printk-panic-string-cleanup.patch added to -mm tree
From: Dave Young <hidave.darkstar@gmail.com>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 6:21 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-02-24 at 22:34 +0100, Frederic Weisbecker wrote:
>> On Wed, Feb 24, 2010 at 01:07:15PM -0800, akpm@linux-foundation.org wrote:
>> >
>
>> That said, it's probably sane to think about a new header to put
>> these tracing prototypes, if it's included by kernel.h,
>> linux/ftrace.h is already filled with non-general purpose things.
>> So may be linux/trace.h ? Yeah this could be confusing, Steve what
>> do you think?
>>
>> And all in one, it would probably better to split this in three
>> patches: one that moves printk helpers out of kernel.h to printk.h,
>> another following the same pattern for panic things and another one
>> for tracing things.
>
> Yeah, I'm fine with moving the tracing related stuff in kernel.h into a
> trace.h file and keep ftrace.h specific to ftrace in general.
>
> But I still find it necessary that trace.h gets included by kernel.h.

Thanks, will do

>
> I can just imaging Thomas yelling at me more when he adds a
> tracing_off() or trace_printk() somewhere and then gets a warning about
> it not being declared.
>
> I also gave that patch a NAK, in case that carries any weight.
>
> -- Steve
>
>
>



-- 
Regards
dave
