Return-Path: <linux-kernel-owner+w=401wt.eu-S1763913AbZANQSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763913AbZANQSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761246AbZANQSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:18:31 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:40702 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761367AbZANQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:18:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nPDKaGARDmpqVpjDj/q+1QzrnAJEGLkOfpBxi0GSS+NsC8kEUiq2ASBkqx2PiDE7H2
         gBDzcKJJIa0u9sQ89+IpqAeqh0aLxU8Q2EKqexG4IfW97SpwkkNXtFgEm9T36fRHwuaq
         ndKbPN/M+oQPgOom8igzwA4xwetGZw/neMp1A=
MIME-Version: 1.0
In-Reply-To: <496DB067.6060402@linux.intel.com>
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>
	 <49594411.60000@linux.intel.com> <20090113174522.GA26965@elte.hu>
	 <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>
	 <496DB067.6060402@linux.intel.com>
Date: Wed, 14 Jan 2009 08:18:29 -0800
Message-ID: <b3ece790901140818i183bc30n2de01b5edaa6a2c7@mail.gmail.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
From: Tim Hockin <thockin@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ying.huang@intel.com, Aaron Durbin <adurbin@gmail.com>,
       priyankag@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 1:29 AM, Andi Kleen <ak@linux.intel.com> wrote:
>
>>
>> I'm 100% on board with that and will even help staff the effort.
>
> Well if you want to change anything the code would be a good idea first to
> establish clearly what is actually broken. I know various areas that need
> improvement (and I have patches fixes most of them), but to my knowledge
> none of them would be fixed by ASCII logging.
>
> Perhaps a good start would be if Ingo could expand what exactly
> he believes is broken currently. At least his earlier "high level" argument
> seems to be large  based on clear misunderstandings of what kind
> of MCE events are common and what not. I don't really blame
> him for that since MCEs are obscure and difficult and badly
> documented (I had a hard time getting up to speed on them myself
> and it took me quite some time). But I hope he doesn't
> dismiss the advice from people who have more experience with
> them than him though.
>
> I wrote a long email earlier in the thread with all the reasons why
> ASCII logging is difficult (like the various atomicity issues and also
> others)
> I haven't heard anyone refuting any of the arguments in there, so I assume
> they
> are agreed one by everyone.
>
> I would appreciate if the people who continue to propose ASCII
> logging would explain how they plan to solve these problems.
>
>> This
>> is something that is VERY HIGHLY desired here.
>
> What is exactly desired?

>From my point of view: a single, consistent, easy logging interface
for the kernel to send *structured data* about hardware/system events
and errors up to userspace.

I don't care if it is ASCII, but it probably can be done in ASCII.
That's the cart before the horse, IMHO.  I just want something more
structured and better suited than printk().

>> I already have a
>> couple peopel looking at this and other HW-error reporting issues.
>
> I have lots of patches pending for over half a year (including
> tons of bug fixes) and they get all delayed again and again with
> very little justification why. So before writing any new code
> it would be good to just get the already pending improvements in.

We'd LOVE your improvements, if they work.  MCE is always a sore point
for us, in that we take too many of them.  Anything to reduce their
impact is a win.

Tim
