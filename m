Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbXJPAca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbXJPAca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762122AbXJPAcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:32:05 -0400
Received: from waste.org ([66.93.16.53]:59611 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbXJPAcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:32:02 -0400
Date: Mon, 15 Oct 2007 19:20:47 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 11/11] maps3: make page monitoring /proc file optional
Message-ID: <20071016002047.GB19691@waste.org>
References: <12.290135367@selenic.com> <1192488599.6118.100.camel@localhost> <4713EEE5.8060706@goop.org> <200710161003.39992.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710161003.39992.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 10:03:39AM +1000, Rusty Russell wrote:
> On Tuesday 16 October 2007 08:51:17 Jeremy Fitzhardinge wrote:
> > Dave Hansen wrote:
> > > On Mon, 2007-10-15 at 17:26 -0500, Matt Mackall wrote:
> > >> +config PROC_PAGE_MONITOR
> > >> +       default y
> > >> +       bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS &&
> > >> MMU +       help
> > >> +         Various /proc files exist to monitor process memory
> > >> utilization: +         /proc/pid/smaps, /proc/pid/clear_refs,
> > >> /proc/pid/pagemap, +         /proc/kpagecount, and /proc/kpageflags.
> > >> Disabling these +          interfaces will reduce the size of the kernel
> > >> by approximately 4kb.
> > >
> > > How about pulling the EMBEDDED off there?  I certainly want it for
> > > non-embedded reasons. ;)
> >
> > That means it will only bother asking you if you've set EMBEDDED;
> > otherwise its always on.
> 
> But it's at the least confusing.  Surely this option should depend on MMU and 
> PROC_FS, and the prompt depend on EMBEDDED?
> 
> That might be implied by the Kconfig layout, but AFAICT this patch removed the 
> explicit MMU dependency.
> 
> Rusty.

Wasn't this your patch? You're right, it ought to say "depends PROC_FS
&& MMU". Will fix.

-- 
Mathematics is the supreme nostalgia of our time.
