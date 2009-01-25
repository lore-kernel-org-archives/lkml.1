Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbZAYOUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbZAYOUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 09:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZAYOT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 09:19:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:7860 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbZAYOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 09:19:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pue1FD+FuQepDoLezM+vgfKZWQhb+ylAb/XYMNsOOAyjZMfDWg18gki6dlGU29GEZS
         2BNcfZ6dTTrOyz836pwLRceya1AAxdDnOCBCdXObdMamLYD0Qo/xZW+laTngLDwvG59H
         z6Ds5ulbiV2Eoe89CCTodNGI+6pwTehX+OpsU=
MIME-Version: 1.0
In-Reply-To: <20090124183746.395f597b.akpm@linux-foundation.org>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com>
	 <20090124183746.395f597b.akpm@linux-foundation.org>
Date: Sun, 25 Jan 2009 15:19:56 +0100
Message-ID: <8db1092f0901250619o2436ba7bkfaa988ccd9fd21bb@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/25 Andrew Morton <akpm@linux-foundation.org>:

>
> Coming out of the hrtimer_hres_active() call, I assume.
>
> Is this new behaviour, or were 2.6.28 and earlier doing it?

2.6.28 and 2.6.28-rcx works OK. 2.6.29-rc1 hangs on resume, so I
cannot check it.



>
> Does this fix it?

I will check it soon.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
