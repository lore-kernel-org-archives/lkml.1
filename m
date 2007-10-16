Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbXJPAD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbXJPAD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXJPADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:03:48 -0400
Received: from ozlabs.org ([203.10.76.45]:48588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbXJPADs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:03:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 11/11] maps3: make page monitoring /proc file optional
Date: Tue, 16 Oct 2007 10:03:39 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dave Hansen <haveblue@us.ibm.com>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
References: <12.290135367@selenic.com> <1192488599.6118.100.camel@localhost> <4713EEE5.8060706@goop.org>
In-Reply-To: <4713EEE5.8060706@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161003.39992.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 08:51:17 Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > On Mon, 2007-10-15 at 17:26 -0500, Matt Mackall wrote:
> >> +config PROC_PAGE_MONITOR
> >> +       default y
> >> +       bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS &&
> >> MMU +       help
> >> +         Various /proc files exist to monitor process memory
> >> utilization: +         /proc/pid/smaps, /proc/pid/clear_refs,
> >> /proc/pid/pagemap, +         /proc/kpagecount, and /proc/kpageflags.
> >> Disabling these +          interfaces will reduce the size of the kernel
> >> by approximately 4kb.
> >
> > How about pulling the EMBEDDED off there?  I certainly want it for
> > non-embedded reasons. ;)
>
> That means it will only bother asking you if you've set EMBEDDED;
> otherwise its always on.

But it's at the least confusing.  Surely this option should depend on MMU and 
PROC_FS, and the prompt depend on EMBEDDED?

That might be implied by the Kconfig layout, but AFAICT this patch removed the 
explicit MMU dependency.

Rusty.

