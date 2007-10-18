Return-Path: <linux-kernel-owner+w=401wt.eu-S965399AbXJRW2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965399AbXJRW2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934587AbXJRW1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:27:35 -0400
Received: from lixom.net ([66.141.50.11]:41373 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933968AbXJRW1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:27:34 -0400
Date: Thu, 18 Oct 2007 17:34:00 -0500
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, paulus@ozlabs.org, lethal@linux-sh.org,
       kyle@parisc-linux.org, grundler@parisc-linux.org
Subject: Re: [PATCH 1/2] bug.h: Introduce HAVE_ARCH_WARN
Message-ID: <20071018223400.GA25281@lixom.net>
References: <20071011171211.GB10877@lixom.net> <20071018151752.09147de5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018151752.09147de5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 03:17:52PM -0700, Andrew Morton wrote:
> On Thu, 11 Oct 2007 12:12:11 -0500
> Olof Johansson <olof@lixom.net> wrote:
> 
> > HAVE_ARCH_WARN is used to determine if an arch already has a __WARN()
> > macro, or if a generic one is needed.
> > 
> > With this, some of the arch-specific WARN_ON() implementations can be
> > made common instead (see follow-up patch for powerpc).
> > 
> 
> Those HAVE_ARCH_foo things are unpleasant.
[...]
> Can't we just do #ifndef __WARN?

Yep, good idea. I'll respin.


-Olof
