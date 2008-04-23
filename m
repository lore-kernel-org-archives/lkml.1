Return-Path: <linux-kernel-owner+w=401wt.eu-S934020AbYDWApD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbYDWApD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbYDWAox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:44:53 -0400
Received: from colo.lackof.org ([198.49.126.79]:48032 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723AbYDWAow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:44:52 -0400
Date: Tue, 22 Apr 2008 18:44:40 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Domenico Andreoli <cavokz@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
Message-ID: <20080423004440.GB21544@colo.lackof.org>
References: <20080420231818.GA2162@ska.dandreoli.com> <1208789018.3640.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208789018.3640.6.camel@localhost.localdomain>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 09:43:38AM -0500, James Bottomley wrote:
> On Mon, 2008-04-21 at 01:18 +0200, Domenico Andreoli wrote: 
> > as soon as I booted my dual PA8600 with 2.6.25 I got 1 CPU less. The
> > only other kernel I successfully used on that box is Debian's 2.6.22-3.
> > 
> > Debian never built 2.6.23 for parisc, 2.6.24 was still hanging last
> > time I checked it, 2.6.25 did not even build until recent -rc. So I am
> > not in the best position to bisect.
> 
> Try this one; it's a corrected version of debian 2.6.24-1 for parisc
> systems:
> 
> http://www.parisc-linux.org/~jejb/parisc_debs/linux-image-2.6.24-1-parisc64-smp_2.6.24-5+b1_hppa.deb

thanks! I can try that out tonight too.

> One thing to try with the J series is a 32 bit
> kernel just in case: they're the only SMP systems that will boot 32
> bits, just in case you could try a 32 bit smp kernel.

J-series are the only workstations that are SMP and boot 32-bit.
PA9000 K/D/R-class servers are SMP and can also boot 32-bit kernels.

> As Dave Anglin said, it could be a config problem, although when I have
> CPUs deconfigured by firmware, they usually don't show up in the
> inventory.

*nod* I don't expect CPUs to show up in inventory if they are
deconfigured in BCH. Maybe J-class firmware has this wrong? *shrug*
Something worth checking I guess.

thanks,
grant
