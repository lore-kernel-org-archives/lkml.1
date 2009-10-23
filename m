Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbZJWKTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbZJWKTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZJWKTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZJWKS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:18:59 -0400
Date: Fri, 23 Oct 2009 12:18:41 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [performance problem] CONFIG_DYNAMIC_FTRACE: Increased kernel 
 build times
In-Reply-To: <520f0cf10910230307k91d0c80sa3d69bcd74d6e1f1@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910231211540.3549@localhost.localdomain>
References: <20091023074533.GA10067@elte.hu> <520f0cf10910230307k91d0c80sa3d69bcd74d6e1f1@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-615147209-1256293126=:3549"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-615147209-1256293126=:3549
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

2009/10/23 Ingo Molnar <mingo@elte.hu> wrote:
> 
> Steve,
> 
> i did an 64-bit allyesconfig build test (with debug_info disabled), with
> and without CONFIG_DYNAMIC_FTRACE set.
> 
> The build time results are:
> 
>  -CONFIG_DYNAMIC_FTRACE:   266.30
>  +CONFIG_DYNAMIC_FTRACE:   296.07 (+11.2%)
> 
> So we get more than 10% build time overhead.
> 
> That's quite high - higher than what i remember having measured
> originally when the first iteration of the mcount code went in.
> 
> This extra overhead comes from the mcount post-processing script
> (scripts/recordmcount.pl) that runs objcopy as well and is written in
> Perl. I think this whole angle needs to be improved - 10% is way too
> high of a price to pay.

Hi Ingo, do you still have the profiling data to share with us?
Was the problem more in objcopy / objdump, rather than in the perl script 
itself?

Thanks

John
--8323328-615147209-1256293126=:3549--
