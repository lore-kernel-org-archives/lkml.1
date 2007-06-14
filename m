Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbXFNHCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbXFNHCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXFNHCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:02:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40036 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbXFNHCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:02:21 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Organization: IBM Linux Technology Center
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RT] fix migrating softirq [cause of network hang]
Date: Thu, 14 Jun 2007 00:02:17 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
References: <1181738836.10408.54.camel@localhost.localdomain>
In-Reply-To: <1181738836.10408.54.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140002.17411.dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 05:47:16 Steven Rostedt wrote:

> This patch temporarily binds the hardirq thread on the CPU that it runs
> the softirqs on.  With this patch I have not seen my network hang. I ran
> it over night, doing compiles and such, and it seems fine. I would be
> able to cause the hang with various loads within a minute, now I can't
> cause it after several minutes.
>
> I'm assuming that this fix may fix other bugs too.
>

I ran 2.6.21-rt10 + this patch with kernbench and then loops building a kernel 
(which would previously rapidly exhaust memory).  It successfully built 400 
kernels with "make -j 32" on an 8 opteron machine with 8 GB of RAM and has so 
far completed 25 "make -j" on the same system.  Looks like a winner to me so 
far.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Realtime Linux Team
