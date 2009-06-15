Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZFOXlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZFOXlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZFOXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:41:41 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:61121 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFOXll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IDVrjr4VZ6FBzWyN2a1J0Aoy2cnvpm54XBwnGPRdrOVzF0v3QVmRTRm3/y0pkquEEy
         uH1fbqBT69sIdJaP8K/PMO27V8MwBspvHtDusCm7d1sMf0Mj4RGLdippQOz7SmxFwcdV
         4F7EkLsUqDY37WLOAYX3hjlFwfU3h1/LODwbg=
MIME-Version: 1.0
In-Reply-To: <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain>
	 <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
Date: Mon, 15 Jun 2009 16:41:43 -0700
X-Google-Sender-Auth: 4464bc343048ca1b
Message-ID: <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
Subject: Re: [GIT pull] ntp updates for 2.6.31
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Miroslav Lichvar <mlichvar@redhat.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 1:16 PM, john stultz<johnstul@us.ibm.com> wrote:
> On Mon, Jun 15, 2009 at 7:06 AM, Thomas Gleixner<tglx@linutronix.de> wrote:
>> Linus,
>>
>> Please pull the latest timers-for-linus-ntp git tree from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-ntp
>>
>> Thanks,
>>
>>        tglx
>>
>> ------------------>
>> John Stultz (2):
>>      ntp: adjust SHIFT_PLL to improve NTP convergence
>>      ntp: fix comment typos
>
> Thomas,
>   Could we hold off on pushing this? I'm still working with Miroslav
> to try to work out a solution here from ntpd user-side.

Linus,
    You probably didn't see this before merging.  Could you yank the
above two patches?  Miroslav (RH package maintainer for ntpd), has
voiced concerns that the SHIFT_PLL patch breaks the NTP design and is
worried it may negatively effect NTP networks of systems running with
different SHIFT_PLL values.

While the patch does greatly improve NTP convergence times, and so far
no negative results have been seen in tests, its out of an abundance
of caution and a desire to keep the adjtimex behavior stable that I
requested Thomas and Ingo to hold off on merging this patch, while I
work with Miroslav to see if we cannot get the same benefit by
adjusting the userspace NTPd.

So if you could revert the two patches until we either sort things out
in userspace or I resubmit, I'd appreciate it.

Sorry for the mixup here.

thanks
-john
