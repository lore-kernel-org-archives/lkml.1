Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbYAJMoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbYAJMoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYAJMn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:43:56 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:3817 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYAJMnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:43:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ih2y2c1N+Ha2/4ZAbinZ4wNMjt1b8EcFicm2gJNbDRnmk381s3Et6jYvBEquC/q+EJnQeIiH7YeLxdJkdCAf1zy3WB6zx+D/ZJeWokrOl3brRu/lMkaeAY/LMqRkygxbc1LTihgaW+haNWddTvNkY/zZXFCAnRRr4uoZ93f/6BE=
Message-ID: <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com>
Date: Thu, 10 Jan 2008 13:43:50 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080110094219.GC17808@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
	 <e85b9d30801100105s60ad675ey1ba939491d01a649@mail.gmail.com>
	 <20080110094219.GC17808@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> really, that module does all sorts of nasty stuff when inserted (and
> then removed), so just to make sure (because you are about to crash your
> box again to take a picture), could you try to boot up without never
> even once loading the nvidia module?

and it still happens ;(
I un-emerged nvidia-drivers & checked via dmesg |grep nv -> it wasn't
loaded, but the box also hanged

it's a little tricky to reproduce it:
I tried it with root-account: firefox-bin, thunderbird-bin wouldn't trigger
user-account (with used account-directory of both apps):
thunderbird-bin triggers it more reliably
probably it has to do with the x86 compatibility apps of gentoo ?
gentoo amd64-users with 32bit firefox & thunderbird - anyone able to
reproduce it ?
it seemingly is being caused by softirq (see pictures; the zen-sources
is also using parts of rt-kernel); approx 1 minute later there also
was a spinlock lockup by syslog-ng (?)

I'll recompile the newest git-sources and see if it's still triggered
with hardirq & softirq disabled ...

http://www.kerneloftruth.neucode.org/other/crash_ia32_64/ (<--
omploader is down so I'll host the picture somewhere else)
hope there's everything revelant to see / read ...

I'll recompile the kernel in question with debug-info probably this
evening - if I find some time, you guys also need frame-pointers set ?

this also happens with rc7-based kernels, btw

>         Ingo
>

Mat
