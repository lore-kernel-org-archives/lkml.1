Return-Path: <linux-kernel-owner+w=401wt.eu-S1422743AbXDRJm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422743AbXDRJm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422740AbXDRJm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:42:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46427 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422743AbXDRJmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:42:14 -0400
Date: Wed, 18 Apr 2007 15:12:11 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gautham Shenoy <ego.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] CPU hotplug with frozen tasks
Message-ID: <20070418094211.GC6474@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704061732.32712.rjw@sisk.pl> <200704160027.58425.rjw@sisk.pl> <c03d1bd00704160250g158de0feqa0c7acd18673969f@mail.gmail.com> <200704162327.59758.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704162327.59758.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch looks good to me. 

On Mon, Apr 16, 2007 at 11:27:58PM +0200, Rafael J. Wysocki wrote:
> 
> ---
>  Documentation/cpu-hotplug.txt             |    9 +++++++--
>  arch/i386/kernel/cpu/intel_cacheinfo.c    |    2 ++
>  arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 ++
>  arch/i386/kernel/cpuid.c                  |    2 ++

[snip]

Though I am wondering what might be the usecase for microcode! 
Guess we'll see that patch soon :-)

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
