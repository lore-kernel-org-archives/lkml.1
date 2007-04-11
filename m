Return-Path: <linux-kernel-owner+w=401wt.eu-S966096AbXDKClX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966096AbXDKClX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 22:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966095AbXDKClX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 22:41:23 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49819 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966056AbXDKClW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 22:41:22 -0400
Date: Tue, 10 Apr 2007 22:41:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao" 
	<fernando@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Build error : 2.6.21-rc6-mm1 on sparc64
Message-ID: <20070411024120.GA26931@Krystal>
References: <20070411004838.GD15262@Krystal> <20070410181854.7d532c59.akpm@linux-foundation.org> <1176257739.19452.13.camel@sebastian.intellilink.co.jp> <20070410193429.ffbfa33c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070410193429.ffbfa33c.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 22:40:53 up 67 days, 16:48,  3 users,  load average: 1.07, 1.29, 1.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 11 Apr 2007 11:15:39 +0900 Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:
> 
> > The problem is that to use hard_smp_processor_id in UP kernels just
> > including linux/smp.h does not suffice anymore. Now
> > hard_smp_processor_id is architecture specific code and consequently
> > asm/smp.h should be included explicitly.
> 
> yeah.  The fact that linux/smp.h only exposes asm/smp.h if CONFIG_SMP hits
> us again and again and again.  It would be good to fix that up, I guess by
> including asm/smp.h unconditionally from within linux/smp.h.
> 
> But that's a separate little project.
> 
> > Mathieu, does the (untested) patch below fix this issue?
> 

With this patch, sparc64 builds correctly. Thanks!


> I'll test it.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
