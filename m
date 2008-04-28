Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbYD1MO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbYD1MO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765725AbYD1MOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:14:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:13369 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765374AbYD1MOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ctoZMM0y+oorkTlVBqxn+KSaxBPZToV3vZNk3+ryyZKt2mLAM5F3M2rxXb1YmLYMXhR3GoC4gMQZb9SM1kJCR4GNspJ/vVYHTuVLuXBX0/Lut89NFcFt5QU0gRFAUWvUFsN1p871GdXTrNjdKuDPvjGvqPmJ7Ly4d8RtWRBFJt8=
Message-ID: <517f3f820804280514p16cb5658ree503816bca20ca3@mail.gmail.com>
Date: Mon, 28 Apr 2008 14:14:46 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: RLIMIT_RTTIME documentation for getrlimit.2
Cc: "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       "Eugene Teo" <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       "Neil Horman" <nhorman@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-man@vger.kernel.org
In-Reply-To: <1209384560.13978.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080208145950.GA3910@kernel.sg> <1207904485.7074.28.camel@twins>
	 <cfd18e0f0804110216l3c679bb6ned83f5d58d1c9d66@mail.gmail.com>
	 <1207905668.7074.32.camel@twins>
	 <cfd18e0f0804110227w37915734r8ca31271a3dfc8ab@mail.gmail.com>
	 <1207906325.7153.2.camel@twins>
	 <cfd18e0f0804110238l66fb60c8pa8ac934a2a43baa7@mail.gmail.com>
	 <4808D1CC.80103@gmail.com>
	 <cfd18e0f0804280444jd558060g6cf5ee7df0248ee1@mail.gmail.com>
	 <1209384560.13978.9.camel@twins>
X-Google-Sender-Auth: fe3b8beb4736211c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Below is the draft text that I will add to the getrlimit.2 man page to describe
>  > RLIMIT_RTTIME.  Does it look okay to you?  (I will add a pointer in
>  > sched_setscheduler.2 to this description in getrlimit.2.)
>  >
>  >       RLIMIT_RTTIME (Since Linux 2.6.25)
>  >              Specifies a limit on the amount of CPU time that a
>  >              process  scheduled  under  a  real-time scheduling
>  >              policy may consume without making a blocking  sys-
>  >              tem  call.   For  the  purpose of this limit, each
>  >              time a process makes a blocking system  call,  the
>  >              count  of  its consumed CPU time is reset to zero.
>  >              The CPU time count is not  reset  if  the  process
>  >              continues  trying to use the CPU but is preempted,
>  >              its   time   slice   expires,    or    it    calls
>  >              sched_yield(2).
>  >
>  >              Upon  reaching the soft limit, the process is sent
>  >              a SIGXCPU  signal.   If  the  process  catches  or
>  >              ignores  this  signal  and continues consuming CPU
>  >              time, then SIGXCPU will  be  generated  once  each
>  >              second  until  the hard limit is reached, at which
>  >              point the process is sent a SIGKILL signal.
>  >
>  >              The intended use of this limit is to stop  a  run-
>  >              away real-time process from locking up the system.
>
>
> Looks excellent, thanks!

Good -- thanks for checking it over.

>  Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>  in so far that is applicable to man pages ;-)

It works for me.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
