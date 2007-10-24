Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbXJXSNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbXJXSNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbXJXSM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:12:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51498 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXJXSM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:12:57 -0400
Date: Wed, 24 Oct 2007 22:17:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, David Miller <davem@davemloft.net>,
       Paul Jackson <pj@sgi.com>, Josh Triplett <josh@freedesktop.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 0/5] Refcount based Cpu Hotplug. V2
Message-ID: <20071024181754.GC345@tv-sign.ru>
References: <20071024052931.GA22722@in.ibm.com> <Pine.LNX.4.64.0710241001160.26202@schroedinger.engr.sgi.com> <20071024180034.GB8663@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024180034.GB8663@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Gautham R Shenoy wrote:
>
> On Wed, Oct 24, 2007 at 10:04:41AM -0700, Christoph Lameter wrote:
> > On Wed, 24 Oct 2007, Gautham R Shenoy wrote:
> > 
> > > This is the version 2 of the refcount based cpu-hotplug "locking" 
> > > implementation. 
> > 
> > Uggh. This introduces a global lock that has to be taken always when 
> > scanning over cpus? 
> 
> Well, no! we take the global lock only while bumping up the refcount. 
> We don't hold the lock while scanning over the cpus. And this is
> definitely an improvement over the lock_cpu_hotplug() global mutex
> we have now.

Just to be sure I didn't miss something... preempt_disable() still works,
yes?

Oleg.

