Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbYIWLma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbYIWLma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYIWLmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:42:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:57190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYIWLmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X55spzFLBCDz1NuzKNt647w/QC9Am7CG66REjdGN45RhXAwAafLEwnpm/yDt8x00dX
         Yz3FLZ6XiGS1Wcs8N3l5Lb4UlsRwTWYybZdGfqD20EVm4dGc4ptdoW7kaXsXwpnHfGt3
         1gyT/MVDn6eDfVMlPwf4nkoDRWf4eqqYCSfRQ=
Message-ID: <c62985530809230442w217642a7o7742c51da905083d@mail.gmail.com>
Date: Tue, 23 Sep 2008 13:42:18 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Patch -tip 0/4] Creation of the initcall tracer
Cc: linux-kernel@vger.kernel.org, "Steven Rostedt" <rostedt@goodmis.org>,
       "Steven Noonan" <steven@uplinklabs.net>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080923100034.GA23118@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D8C516.4090706@gmail.com> <20080923100034.GA23118@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/23 Ingo Molnar <mingo@elte.hu>:
> Note that i've done a couple of small changes to your patches:
>
>  - i've done the following renames:
>
>      :1,$s/INITCALL_TRACER/BOOT_TRACER/g
>      :1,$s/trace_initcall/trace_boot/g
>      :1,$s/initcall_trace/boot_trace/g
>
>   the reasoning: we eventually want to extend this new tracer to all
>   things "bootup delay", not just initcalls - hence calling it an
>   'initcall tracer' would be too limiting.

That's right. It's a good thing.

>
>   The goal is to help the Arjan's fastboot project to achieve 5 seconds
>   to-GUI bootup times like this:
>
>      http://www.youtube.com/watch?v=s7NxCM8ryF8
>
>   [ Even if you know what a 5 seconds bootup is, you've got to check
>     this "From Naught to Sixty in 5 seconds" video ;-) ]

Hehe! I wasn't aware of this project :)

>  - there were a few overlong lines in the commit logs and in the Kconfig
>   desciption - i fixed them up. You should check your email client and
>   your editor for line length settings - currently you seem to have no
>   line breaks at all.

That will be a great day when I will be able to send a not line/space
damaged patch :-)

>  - I also corrected a few capitalization things in commit subject lines
>   and corrected a few minor coding style errors - you can avoid these
>   by running scripts/checkpatch.pl over your patches. Nothing overly
>   serious - but you should diff against tip/master to see what the
>   changes are.

Hmm I ran this script and it warned about a non conventional format
(%Lu instead of %llu). Since I picked it from the printk in main.c
I thought that was a false warning. Ok I will remember about correct
format for the next times.

> i've integrated tip/tracing/fastboot into tip/master and have started
> testing it. It passed the basic tests already so i've just pushed out
> the new tip/master. Please double-check that i have not messed up the
> rename or the integration somewhere.

I can't test the master branch yet. But as far as I read the diff, it
seems correct.

> all in one, nice stuff!

Thanks Ingo :)
I will improve it as I can...
