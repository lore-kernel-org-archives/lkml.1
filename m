Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbZCZVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbZCZVyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbZCZVyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:54:11 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:35834 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZCZVyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xQ4pQ0jxK2LXfd3AdAI46InMan8Sms9FB01aBG679zNL5EO4sI+kn8Zq9bdep8IQpX
         i76SCjQY03LzGh91vS0FRdFl6vb3PFhFV/ZFcnsjGD/3+WVhNzXIdNX1z7BJGFQ+N6o1
         SkuwBuDlttuQCmxwfpzWf12RgTbilAVnxMuRg=
MIME-Version: 1.0
In-Reply-To: <9b2b86520903260958r790e5459r553308311522e88f@mail.gmail.com>
References: <4e5e476b0903260847m1de3e976ne20279df359176cf@mail.gmail.com>
	 <9b2b86520903260958r790e5459r553308311522e88f@mail.gmail.com>
Date: Thu, 26 Mar 2009 22:54:07 +0100
Message-ID: <4e5e476b0903261454h1525c30chdc86dbcb1cf3cb5c@mail.gmail.com>
Subject: Re: "ACPI: EC: missing confirmations, switch off interrupt mode" 
	wastes time on startup
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 5:58 PM, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 3/26/09, Corrado Zoccolo <czoccolo@gmail.com> wrote:
>
> [CC linux-acpi]
>
> Thanks for reporting this bug / issue.  Your hardware is probably
> defective by design - that is, it doesn't follow the ACPI spec.  But
> we can't blame users for that :-).
>
> I take it this isn't a regression, i.e. if you've tried earlier
> kernels, it's never worked any better?

This is new hardware, and 2.6.29 is the first kernel I installed, so I
can't say.

>
> You say this is a severe delay - but your logs show 0.5 seconds only,
> is that right?  Just to get it clear.
>
Right, but Arjan showed that 1s boot time for kernel is possible, so
0.5s is quite severe respect to this :).
I'm still way far from 1s, though, due to an other issue that wastes
>1s, i.e. tsc clocksource unstable.

> Currently there is no option to force polling, sorry.  I'm _guessing_
> this was a deliberate omission.  But I can sympathise that even 0.5s
> boot delay is bad on a netbook.
>
Yes. Do you think that changing olpc_ec_timeout kernel parameter may
help in getting the timeout sooner?

> Feel free to create a new bugzilla entry.  You can attach the full
> output of dmesg, but acpidump is probably not required.  What would be
> really helpful is if you could file on bugzilla, and attach a full
> debug trace.  I.e. as well as the normal dmesg, attach the dmesg
> output after recompiling with this change:
>

bug: http://bugzilla.kernel.org/show_bug.cgi?id=12949
full debug dmesg: http://bugzilla.kernel.org/attachment.cgi?id=20695

Thanks,
Corrado

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
