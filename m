Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXBPHZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXBPHZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932989AbXBPHZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:25:01 -0500
Received: from gw.goop.org ([64.81.55.164]:45132 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985AbXBPHZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:25:00 -0500
Message-ID: <45D55C4D.1060807@goop.org>
Date: Thu, 15 Feb 2007 23:25:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Hecht <dhecht@vmware.com>, Andi Kleen <ak@muc.de>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@xensource.com>,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       Steven Hand <steven.hand@cl.cam.ac.uk>
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org>	<20070216022531.570154735@goop.org>	<45D54BD5.8010707@vmware.com> <20070215230611.d89e26be.akpm@linux-foundation.org>
In-Reply-To: <20070215230611.d89e26be.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 22:14:45 -0800 Dan Hecht <dhecht@vmware.com> wrote:
>
>   
>>>  config PREEMPT
>>>  	bool "Preemptible Kernel (Low-Latency Desktop)"
>>> +	depends on !XEN
>>>  	help
>>>  	  This option reduces the latency of the kernel by making
>>>  	  all kernel code (that is not executing in a critical section)
>>>
>>>       
>
> Oh, so that's why it doesn't break when CONFIG_PREEMPT=y.  In which case
> that preempt_disable() I spotted is wrong-and-unneeded.
>
> Why doesn't Xen work with preemption??
>   

I've forgotten the details.  Ian?  Keir?  Steven?  Maybe it can be done.

    J
