Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbYGaWge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbYGaWge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbYGaWgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:36:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56620 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbYGaWgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:36:22 -0400
Date: Fri, 1 Aug 2008 00:36:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       wim@iguana.be
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080731223629.GT23938@one.firstfloor.org>
References: <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731221924.GD8563@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 03:19:24PM -0700, Suresh Siddha wrote:
> On Thu, Jul 31, 2008 at 03:14:35PM -0700, Andi Kleen wrote:
> > > Kernel was enabling watchdog, with out the userspace having the
> > > heartbeat daemon....
> > 
> > Watchdog are  normally only armed when someone opens the device
> > first.
> 
> But thats not what I see with for ex with, w83627hf_wdt.c
> 
> Its done at the module_init time. (while I thought it should be
> really done when some user level app opens the device, probably
> its poorly written to take care if the kernel panics before starting userland.
> but kernel can even die before the watchdog driver load aswell ;-)

Ok that watchdog driver is just broken then. Putting the watchdog maintainer
into cc.

-Andi
> 
