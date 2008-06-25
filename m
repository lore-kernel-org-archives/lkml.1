Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYFYMUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYFYMUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbYFYMU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:20:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:7765 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbYFYMU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S/tuWyYIPd94UhBBR+Cq3LFCwtTpGzwH8oOpsKg57goZlG4GuebB4FZ9ZkEDwbrOmO
         Of7gBsWjBzcNHw1MQ22jrbVEUUsviPsyroY8RbnKMdz5DMKWHDfDOq+xjw9VKjd3FKGX
         FvOsFEXuZzihrKP2TH8tZTI95wT/vzp3g/g04=
Message-ID: <cfd18e0f0806250520u565d512as298f024df06da857@mail.gmail.com>
Date: Wed, 25 Jun 2008 14:20:26 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: When did High-Resolution Timers hit mainline?
Cc: "Ingo Molnar" <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>,
       "Bart Van Assche" <bart.vanassche@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0806250900240.3297@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
	 <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
	 <alpine.LFD.1.10.0806250900240.3297@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Wed, Jun 25, 2008 at 9:09 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 25 Jun 2008, Michael Kerrisk wrote:
>>    High-Resolution Timers
>>        Before  Linux  2.6.16,  the  accuracy of timer and sleep system
>>        calls (see below) was also limited by the size of the jiffy.
>>
>>        Since  Linux  2.6.16,  Linux  supports  high-resolution  timers
>>        (HRTs),  optionally  configurable  since kernel 2.6.21 via CON-
>>        FIG_HIGH_RES_TIMERS.  On a system that supports HRTs, the accu-
>>        racy  of  sleep and timer system calls is no longer constrained
>>        by the jiffy, but instead can be as accurate  as  the  hardware
>>        allows (microsecond accuracy is typical of modern hardware).
>
> Hmm, that's a bit backwards. We changed the internal handling of those
> interfaces to hrtimers in 2.6.16, but the accuracy is still jiffies
> unless you have CONFIG_HIGH_RES_TIMERS enabled (which is only possible
> as of 2.6.21) and your system provides the necessary hardware.

So then it's simply enough to say:

Since  Linux  2.6.17,  Linux  optionaly supports  high-resolution  timers
(configurable via CONFIG_HIGH_RES_TIMERS).

right?

>>        HRTs are not supported on all hardware architectures.  (Support
>>        is provided on x86, arm, and powerpc, among others.)
>
> Also you might point out that you can check whether high resolution
> timers are active via clock_getres() or by checking the resolution
> entry in /proc/timer_list.

Okay -- thanks.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
