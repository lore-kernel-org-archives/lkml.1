Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYFYMQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYFYMQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYFYMQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:16:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:13308 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYFYMQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sgs2qgLavU0xrw/zrNOpVdvp12yr5ctljZm7wrUvM1l0GXqzZ04t1TxFD1C/j1+WoW
         xW7tSqpnINFMF9oncBe5Nbii64G/cQSW/rwCOrdQZ5QIh2S1/x76eja89Igh89pae/li
         hlNVbAseXes411VkdGgcdxYDOE/qRKUAACr2w=
Message-ID: <cfd18e0f0806250516v1e737842l7d8a7a4c93ba1b22@mail.gmail.com>
Date: Wed, 25 Jun 2008 14:16:42 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: When did High-Resolution Timers hit mainline?
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <e2e108260806242332i2138f7f7t63626d45a33fdce2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
	 <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
	 <e2e108260806242332i2138f7f7t63626d45a33fdce2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

Thanks for taking a look at this.

On Wed, Jun 25, 2008 at 8:32 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Wed, Jun 25, 2008 at 6:08 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>>   The Software Clock, HZ, and Jiffies
>>       The accuracy of various system calls that set timeouts,  (e.g.,
>>       select(2),   sigtimedwait(2))   and  measure  CPU  time  (e.g.,
>>       getrusage(2)) is limited by  the  resolution  of  the  software
>>       clock,  a clock maintained by the kernel which measures time in
>>       jiffies.  The size of a jiffy is determined by the value of the
>>       kernel constant HZ.
>
> Maybe "size of a jiffy" should be replaced by "duration of a jiffy" ?

Actually, IMO size feels better in this context.

> An explanation of the impact of CONFIG_NO_HZ is missing.

I'm not sure whether it's needed here.  Can you say a little more
about why you think something needs to be said (and perhaps even
suggest some text then)?

> You also missed the fact that since the 2.6 kernel there are two
> constants related to time resolution, namely HZ and USER_HZ. HZ is the
> frequency of the timer interrupt, and 1/USER_HZ is the time resolution
> for system calls that use jiffies as time unit (e.g. the five values
> returned by the times() system call). The time resolution of e.g. the
> select() and poll() system calls is 1.0/HZ since the timeout for these
> system calls is specified as a struct timeval or struct timespec.

Good point!  I will come up with some text for this.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
