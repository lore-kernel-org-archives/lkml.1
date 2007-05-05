Return-Path: <linux-kernel-owner+w=401wt.eu-S1423188AbXEEJba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423188AbXEEJba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 05:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423212AbXEEJba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 05:31:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423188AbXEEJba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 05:31:30 -0400
Date: Sat, 5 May 2007 11:31:20 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: Remove constructor from buffer_head
Message-ID: <20070505093119.GC26000@wotan.suse.de>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com> <20070504134212.c18d2d65.akpm@linux-foundation.org> <20070504143347.9a1d6a34.akpm@linux-foundation.org> <200705050122.05275.ak@suse.de> <20070504164529.f64a2985.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504164529.f64a2985.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 04:45:29PM -0700, Andrew Morton wrote:
> On Sat, 5 May 2007 01:22:05 +0200
> Andi Kleen <ak@suse.de> wrote:
> 
> > > 2.6.21:
> > > 
> > > akpm2:/home/akpm# opreport -l /boot/vmlinux-$(uname -r) | head -50
> > > opreport error: No sample file found: try running opcontrol --dump
> > > or specify a session containing sample files
> > 
> > For me it works on a slightly post 2.6.21 kernel with suse oprofile-0.9.2-21
> > 
> > Did you try opcontrol --dump? 
> 
> Yes, tried various things.  There's just nothing turning up in /var/lib/oprofile.
> 
> Chuck appears to be claiming that 2.6.21 oprofile is known to be broken,
> but I never heard anything about that.

Hmm, after a opcontrol --reset i see the same issue now. Don't know what's 
wrong, but it must be something different from the .20 perfctr allocation
problem.

It looks like the daemon doesn't get any data from the kernel


-Andi
