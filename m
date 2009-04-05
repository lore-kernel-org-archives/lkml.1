Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZDESj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZDESj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZDESjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:39:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:27836 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZDESjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VGgl748ZfxSQhw+u5WU2qrAZgFB21Qnig0GcAmHPoYyqKTamR65nbBDU2kmRL+3T3V
         QNeN+wbClrmYViyL+lxQKLHtwUEOCHTzdd26z7JMG+soYTrJGPLbEJKSGSYqP1/dZboJ
         U8M9WH2ZJjJ6i92ERF/KdmLsM+P0HU4/7nR74=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904051257470.747@localhost.localdomain>
References: <3efb10970904030502q1068731fl5b92f93d5341b43e@mail.gmail.com>
	 <alpine.LFD.2.00.0904051257470.747@localhost.localdomain>
Date: Sun, 5 Apr 2009 20:39:11 +0200
X-Google-Sender-Auth: a4aa6121b1fe30fb
Message-ID: <3efb10970904051139ue3802b1ib33487418188e4bc@mail.gmail.com>
Subject: Re: System deadlock on 2.6.24-rt20 (-rt27 panics on 
	locking-api-selftests)
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

>> I integrated -rt27, but this one fails on the locking api-selftests.
>> Is this a bug in the selftest? Or is there a real locking bug behind
>> it?
>
> Don't think so. The rw locks fixups which we did between -rt20 and
> -rt27 might have screwed the lockdep selftests where we create
> deadlock situations.

This is what I hoped for ;-)  (A bug in the testtooling...)

> What happens if you disable the self tests ?

The system boots and seems to run properly. We did not yet test for a
longer period of time, but the first looks are that the hangups we had
are gone now. But it would be good for the peace of mind if the
locking-selftest was working properly.

Thanks.

Kind Regards,

Remy
