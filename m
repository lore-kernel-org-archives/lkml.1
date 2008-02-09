Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYBIJ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYBIJ3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYBIJ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:29:11 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3117 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYBIJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:29:09 -0500
Message-ID: <47AD725E.6050903@free-electrons.com>
Date: Sat, 09 Feb 2008 10:29:02 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?UTF-8?B?U2ltb24gSG9sbSBUaMO4Z2Vyc2Vu?= <odie@cs.aau.dk>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some	processors
References: <200802082347.25364.michael-lists@free-electrons.com>	 <1202512812.17934.680.camel@cinder.waste.org> <1202545817.6722.24.camel@odie.local>
In-Reply-To: <1202545817.6722.24.camel@odie.local>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2008 09:30 AM, Simon Holm Thøgersen wrote:
> The build of my currently running kernel for my laptop has
> $ size -t amd.o cyrix.o centaur.o transmeta.o intel.o nexgen.o umc.o
>    text	   data	    bss	    dec	    hex	filename
>    2809	    316	      0	   3125	    c35	amd.o
>    2387	    856	      0	   3243	    cab	cyrix.o
>    1514	    312	      0	   1826	    722	centaur.o
>    1279	    312	      0	   1591	    637	transmeta.o
>    1783	    316	      0	   2099	    833	intel.o
>     126	    312	      0	    438	    1b6	nexgen.o
>      41	    312	      0	    353	    161	umc.o
>    9939	   2736	      0	  12675	   3183	(TOTALS)
>
> That is without optimize for size compilation, with that set I get
> $ size -t amd.o cyrix.o centaur.o transmeta.o intel.o nexgen.o umc.o
>    text	   data	    bss	    dec	    hex	filename
>    2300	    316	      0	   2616	    a38	amd.o
>    2132	    820	      0	   2952	    b88	cyrix.o
>    1325	    312	      0	   1637	    665	centaur.o
>    1151	    312	      0	   1463	    5b7	transmeta.o
>    1575	    316	      0	   1891	    763	intel.o
>     107	    312	      0	    419	    1a3	nexgen.o
>      41	    312	      0	    353	    161	umc.o
>    8631	   2700	      0	  11331	   2c43	(TOTALS)
>
> I don't think the code changes in the patch do much with respect to
> size.
>   
Thanks for this report. Don't you think it's still useful to save up to
12 K of code that you don't use if you just have an Intel processor (for
example)?

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

