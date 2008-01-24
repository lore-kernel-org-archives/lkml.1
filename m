Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYAXVF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYAXVF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYAXVFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:05:50 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:42184 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652AbYAXVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:05:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAP6MmEdMQWYq/2dsb2JhbACBV61u
Date: Thu, 24 Jan 2008 16:05:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 03/26] Move Kconfig.instrumentation to arch/Kconfig and
	init/Kconfig
Message-ID: <20080124210547.GB1647@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203333.499728934@polymtl.ca> <20080124130051.ec521347.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080124130051.ec521347.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:05:01 up 82 days,  2:10,  6 users,  load average: 0.49, 1.10,
	1.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Thu, 24 Jan 2008 15:27:09 -0500 Mathieu Desnoyers wrote:
> 
> > Move the instrumentation Kconfig to
> > 
> > arch/Kconfig for architecture dependent options
> >   - oprofile
> >   - kprobes
> > 
> > and
> > 
> > init/Kconfig for architecture independent options
> >   - profiling
> >   - markers
> > 
> > Remove the "Instrumentation Support" menu. Everything moves to "General setup".
> 
> Was this done based on a suggestion from someone (Linus)?
> I prefer an Instrumentation menu, but whatever...
> 

Yes, it was Linus'suggestion. I prefer the instrumentation menu too, but
in order to be consistent, we would have to create an instrumentation/
directory in the kernel tree.

Mathieu

> 
> > Delete the kernel/Kconfig.instrumentation file.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Linus Torvalds <torvalds@linux-foundation.org>
> > CC: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  arch/Kconfig                   |   28 ++++++++++++++++++++
> >  arch/alpha/Kconfig             |    2 -
> >  arch/arm/Kconfig               |    2 -
> >  arch/blackfin/Kconfig          |    2 -
> >  arch/cris/Kconfig              |    2 -
> >  arch/frv/Kconfig               |    2 -
> >  arch/h8300/Kconfig             |    2 -
> >  arch/ia64/Kconfig              |    2 -
> >  arch/m32r/Kconfig              |    2 -
> >  arch/m68k/Kconfig              |    2 -
> >  arch/m68knommu/Kconfig         |    2 -
> >  arch/mips/Kconfig              |    2 -
> >  arch/parisc/Kconfig            |    2 -
> >  arch/powerpc/Kconfig           |    2 -
> >  arch/ppc/Kconfig               |    2 -
> >  arch/s390/Kconfig              |    2 -
> >  arch/sh/Kconfig                |    2 -
> >  arch/sh64/Kconfig              |    2 -
> >  arch/sparc/Kconfig             |    2 -
> >  arch/sparc64/Kconfig           |    2 -
> >  arch/um/Kconfig                |    2 -
> >  arch/v850/Kconfig              |    2 -
> >  arch/x86/Kconfig               |    2 -
> >  arch/xtensa/Kconfig            |    2 -
> >  init/Kconfig                   |   12 ++++++++
> >  kernel/Kconfig.instrumentation |   55 -----------------------------------------
> >  26 files changed, 40 insertions(+), 101 deletions(-)
> 
> ---
> ~Randy

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
