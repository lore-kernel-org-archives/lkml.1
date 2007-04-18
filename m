Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXDRRDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXDRRDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbXDRRDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:03:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbXDRRD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:03:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC][PATCH][EXPERIMENTAL] CPU hotplug with frozen tasks
Date: Wed, 18 Apr 2007 19:07:09 +0200
User-Agent: KMail/1.9.5
Cc: Gautham Shenoy <ego.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <200704061732.32712.rjw@sisk.pl> <200704162327.59758.rjw@sisk.pl> <20070418094211.GC6474@in.ibm.com>
In-Reply-To: <20070418094211.GC6474@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181907.10288.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 18 April 2007 11:42, Gautham R Shenoy wrote:
> Hi,
> 
> The patch looks good to me. 
> 
> On Mon, Apr 16, 2007 at 11:27:58PM +0200, Rafael J. Wysocki wrote:
> > 
> > ---
> >  Documentation/cpu-hotplug.txt             |    9 +++++++--
> >  arch/i386/kernel/cpu/intel_cacheinfo.c    |    2 ++
> >  arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 ++
> >  arch/i386/kernel/cpuid.c                  |    2 ++
> 
> [snip]
> 
> Though I am wondering what might be the usecase for microcode! 

Well, for 2.6.21-rc I had to introduce the variable suspend_cpu_hotplug (in
cpu.c) and make the microcode driver use it to distinguish between the 'normal'
and suspend-related CPU hotplug.  I'd like to get rid of this ugliness ASAP.

> Guess we'll see that patch soon :-)

Yes, in a couple of days.  I have to make both patches apply to -mm first. :-)

Greetings,
Rafael
