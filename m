Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0BVPhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:37:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38172 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0BVPhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xHWFHJewTY+sJPJ22s2CLhMGztd3sKS8zd/ev/byVT3u+RLSiIsmlF//8BcyRLaB9o
         EKNU885f+Aw9Jq4nsqpQc72kG2cYtzvJ0h5mqgvs9n2EFQsnPTuMjUbPk8QzA3n3UDes
         BENt5lenGZuCWecnc06FzgDtp+wXPz0AAZ5AY=
MIME-Version: 1.0
In-Reply-To: <20100217230854.GA25636@Krystal>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com>
	 <1266337450.24271.140.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain>
	 <20100216164744.GA25115@Krystal>
	 <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain>
	 <20100216170540.GA28039@Krystal>
	 <f5a7b3811002170236i6c560eadp2de7deb10082db4f@mail.gmail.com>
	 <20100217230854.GA25636@Krystal>
Date: Mon, 22 Feb 2010 21:07:13 +0530
Message-ID: <f5a7b3811002220737r502e75c1w5ab5a64b6cc27b68@mail.gmail.com>
Subject: Re: [ltt-dev] LTTng 0.193 fixes RT kernel support
From: naresh kamboju <naresh.kernel@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 4:38 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> * naresh kamboju (naresh.kernel@gmail.com) wrote:
>> Hi,
>>
>> On Tue, Feb 16, 2010 at 10:35 PM, Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> [...]
>> > Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
>> > saner del_timer_sync() scheme to delete the timers.
>>
>> Could you give more info regarding, what kind of changes we can work on.
>> let me also work around on it.
>>
>
> I just released LTTng 0.193 for kernel 2.6.32.4 which includes patches
> fixing these odd per-cpu timer teardowns.

I have downloaded LTTng 0.193 patches and viewed i can see below patches

1. lttng-transport-lockless-add-timer-on-works-with-del-timer-sync.patch
2. omap-trace-clock-use-del-timer-sync.patch
3. x86-trace-clock-use-mod-timer.patch
4. trace-clock-32-to-64-use-del-timer-sync.patch

Thank you very much.

>The patches concerned are:
>
> lttng transport lockless add timer on works with del timer sync
> omap trace clock use del timer sync
> x86 trace clock use mod timer
> trace clock 32 to 64 use del timer sync
>
> (they are at the end of the LTTng 0.193 tree)
>
> Feedback is welcome,

I have ARM environment and currently working with 2.6.29-RT on ARM-SMP
hardware.
Let me test and comeback.

Best regards,
Naresh Kamboju
>
> Thanks,
>
> Mathieu
>
> --
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>
