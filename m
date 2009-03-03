Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZCCNyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZCCNyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZCCNx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:53:58 -0500
Received: from mx0.towertech.it ([213.215.222.73]:35841 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752105AbZCCNx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:53:57 -0500
Date: Tue, 3 Mar 2009 14:53:45 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Geert.Uytterhoeven@sonycom.com, Richard Zidlicky <rz@linux-m68k.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
Message-ID: <20090303145345.3751a471@i1501.lan.towertech.it>
In-Reply-To: <alpine.LRH.2.00.0903031121280.31985@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<20090220170454.04382e9e@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
	<1235511327.18632.73.camel@macbook.infradead.org>
	<20090224231154.60ba18d6@i1501.lan.towertech.it>
	<1235514727.18632.93.camel@macbook.infradead.org>
	<alpine.LRH.2.00.0902251059110.4063@vixen.sonytel.be>
	<20090225111836.621412c1@i1501.lan.towertech.it>
	<20090227185514.GA1071@linux-m68k.org>
	<alpine.LRH.2.00.0903021051040.25117@vixen.sonytel.be>
	<20090302110310.35af50ea@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0903021116450.25117@vixen.sonytel.be>
	<20090302120950.0d35e06c@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0903031121280.31985@vixen.sonytel.be>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009 11:41:23 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> rtc-generic is already in the kernel, it's just called rtc-parisc ;-)

 Really? I never saw it :)

> >  But I'd strongly suggest to plan and execute a conversion process.
> 
> So would you accept a patch series that:
>   1. Adds the missing module aliases to rtc-parisc (which is a bugfix),
>   2. Moves the platform device creation out of rtc-ppc and into arch-specific
>      code (which is also a bugfix),
>   3. Consolidates rtc-parisc and rtc-ppc into rtc-generic (which is a cleanup),
>   4. Makes rtc-generic dependent on PARISC, PPC, and M68K (the existing
>      [sg]et_rtc_time() users):
>        a. without introducing ARCH_HAS_GENERIC_RTC,
>        b. with a big fat warning in the Kconfig comment not relaxing the
>           dependencies, as it's supposed to go away.
>   4. Converts the PS3 RTC support into a separate driver, called rtc-ps3
>      (as a bonus ;-)
> 
> ? If yes, I'll cook it up.
> 
> Other RTC platform support can be converted into separate drivers later.

 Seems reasonable. But please add a list of users of rtc-generic and information
 about their respective rtc hardware along with some general planning about
 which future driver would cover which users.

 And let's hope this is a beginning :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

