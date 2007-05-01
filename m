Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbXEAQ3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbXEAQ3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbXEAQ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:29:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:44145 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbXEAQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ny08rOogOtf2g/bqS07JQkq6qH/8K9eLezrPVHITpCGBCmVjnbBDPW6Fx0ws0bWk3uQ7Ft045RBBmdj9XSFpyVlYVfLZLq+1lN0LFFklHBtSZmkAL7qTI6k1s3WyAtJmdHEH7Ti1E2vrx1Ysmkjbeg/uVC9p+Ql2jhy2A39dcLE=
Message-ID: <46376AD9.3020701@gmail.com>
Date: Tue, 01 May 2007 20:29:13 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Paul Sokolovsky <pmiscml@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel-discuss@handhelds.org
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
References: <1354376306.20070501080806@gmail.com> <46374645.2030900@gmail.com> <1068016897.20070501173657@gmail.com>
In-Reply-To: <1068016897.20070501173657@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Sokolovsky wrote:
> Hello Dmitry,
>
> Tuesday, May 1, 2007, 4:53:09 PM, you wrote:
>
>> I think your referring to the term "SoC (system-on-chip)" is confusing
>> (at least for me). You rather consider companion chips than SoCs.
>
>> Yes, any chip integrating a number of controllers could be considered
>> as a system-on-chip but if the chip doesn't make sense without
>> some master chip (processor) I'd consider the chip as a companion
>> (to the processor) chip.
>
>         Ditto for me - I find "companion" thing confusing. What's
> important for the RFC/topic discussed is that it is integrated
> controller with many diversified functions, not what it is helper to
> something. 
It's exactly helper. It helps to expand functionality of a main
processor.
> I understand that for many people SoC means CPU with ties,
> but IMHO, it's less stretch to take such chip, remove CPU, and still
> call it a SoC,
I do not know any chip that would be "just add a CPU and you'll get
a complete system", do you?

>  than call an integrated audio/touchscreen controller a
> companion chip (well, of course it is; and RAM chip too ;-) ).
>
>         Either way, I don't pledge to be a HW designer with
> contemporary lexicon. The aim was simple - as a single word would be
> too ambiguous, general, or vice-versa, omitting, then acronym is
> needed, hopefully existing, and not new, and SoC is the most fitting
> TLA, IMHO.
If you used ASIC acronym it would be more appropriate and not so
ambiguous.

What kind of chips you deal with does not fit ASIC acronym?
>  But I'm open to specific suggestions for improvement. For
> example, if I was to write a Documentation/ entry for that, I'd mention
> companion chips, peripheral/integrated controllers, etc.
"peripheral/integrated controllers" are also within companion chips.

Every type of CMOS devices may be a part of processor chip or
may be a standalone chip as well as a group of CMOS devices
may be a part of the proc chip or may organize a standalone chip.

When your chip is missing a processor device then it is not
a system but a part of a system, you can not build a complete
system on a such chip, so you can not call it a "system-on-chip".
>  But renaming
> drivers/soc/ to drivers/companion/ would be more confusing,
Not for me.
>  as the
> concept described is not tied to companion chips per se (even though
> many of chips we (handhelds.org) deal with, can be classified as
> such).
>
>

Regards,
Dmitry
