Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYGHPqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYGHPqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYGHPqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:46:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33634 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYGHPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:46:09 -0400
Date: Tue, 8 Jul 2008 08:39:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-Id: <20080708083902.e564face.randy.dunlap@oracle.com>
In-Reply-To: <20080708051629.GA12595@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	<uBi7uNfg81L.A.XLC.s0LcIB@albercik>
	<20080706111750.a6d77e81.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
	<20080707063218.GC23583@elte.hu>
	<20080707113917.6fda3f7d.randy.dunlap@oracle.com>
	<20080707154042.04bb492e.randy.dunlap@oracle.com>
	<20080708051629.GA12595@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 07:16:29 +0200 Ingo Molnar wrote:

> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > > $ git bisect start
> > > $ git bisect bad v2.6.26-rc1
> > > $ git bisect good v2.6.25
> > > 
> > > That's only about 1.29M lines of changes.
> > 
> > git bisect and normal rebooting did not find a problem.
> > 
> > I'll repeat this using kexec to boot the new kernel and see if that 
> > locates any issues... since I normally use kexec to load/test new 
> > kernels and that was how the failure occurred (occurs).
> 
> ah, so the hang only occurs if you kexec a post-v2.6.25 kernel? (from 
> any other kernel, or from a post-v2.6.25 kernel?)

Host (first) kernel is 2.6.25 with NUMA=y.
kexec of 2.6.25 with NUMA=n works, kexec of 2.6.26-rc[123456789] with
NUMA=n fails/hangs.  kexec of 2.6.26-rc* with NUMA=y works.

kernel configs will be in next email reply to YH.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
