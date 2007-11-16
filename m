Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbXKPDKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbXKPDKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbXKPDKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:10:25 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:34107 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756574AbXKPDKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:10:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJqYPEdMROHU/2dsb2JhbACBX453
Date: Thu, 15 Nov 2007 22:10:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [patch 2/4] Add ARCH_SUPPORTS_OPROFILE
Message-ID: <20071116031021.GF16953@Krystal>
References: <20071116015925.175012068@polymtl.ca> <20071116020027.207316215@polymtl.ca> <20071115180830.106d594c.akpm@linux-foundation.org> <20071116022319.GD16953@Krystal> <20071115183043.25197ad1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071115183043.25197ad1.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:09:29 up 12 days,  8:14,  8 users,  load average: 0.92, 0.75,
	0.84
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 15 Nov 2007 21:23:19 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > On Thu, 15 Nov 2007 20:59:27 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > >  arch/x86/Kconfig.i386          |    1 +
> > > >  arch/x86/Kconfig.x86_64        |    1 +
> > > 
> > > these no longer exist.
> > 
> > Ok, should I prepare a fix or is it duplicated work ?
> 
> I fixed the new patches, then had a go at fixing the thus-broken kprobes
> ones and the resulting mess caused me to give up and drop both patchsets.
> 
> 

Arg.. yet another change of mid from Sam.. he prefers 

HAVE_* to ARCH_HAS_*.

will it ever stop...... ?

Please don't merge my previous patchset, I'll resend them. I will adapt
them accordingly.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
