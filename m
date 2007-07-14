Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbXGNRTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbXGNRTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbXGNRTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:19:18 -0400
Received: from mail001.aei.ca ([206.123.6.130]:39153 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116AbXGNRTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:19:17 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v19
Date: Sat, 14 Jul 2007 13:19:12 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070706173319.GA2356@elte.hu>
In-Reply-To: <20070706173319.GA2356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707141319.13270.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I run a java application at nice 15.  Its been a background application here for as long
as SD and CFS have been around.  If I have a compile running at nice 0, with v19 java 
gets so little cpu that the the wrapper that runs to monitor it is timing out waiting for 
it to start.  This is new in v19 - something in v19 is not meshing well with my mix 
of applications...

Kernel is gentoo 2.6.22-r1 + cfs v19

How can I help to debug this?
Ed Tomlinson

On Friday 06 July 2007 13:33, Ingo Molnar wrote:
> i'm pleased to announce release -v19 of the CFS scheduler patchset.
> 
> The rolled-up CFS patch against today's -git kernel, v2.6.22-rc7, 
> v2.6.22-rc6-mm1, v2.6.21.5 or v2.6.20.14 can be downloaded from the 
> usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
>  
> The biggest user-visible change in -v19 is reworked sleeper fairness: 
> it's similar in behavior to -v18 but works more consistently across nice 
> levels. Fork-happy workloads (like kernel builds) should behave better 
> as well. There are also a handful of speedups: unsigned math, 32-bit 
> speedups, O(1) task pickup, debloating and other micro-optimizations.
