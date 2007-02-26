Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXBZT1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXBZT1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030480AbXBZT1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:27:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46844 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030479AbXBZT1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:27:51 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: john stultz <johnstul@us.ibm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org
In-Reply-To: <1172448057.3971.9.camel@shinybook.infradead.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 11:27:47 -0800
Message-Id: <1172518068.15970.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 19:00 -0500, David Woodhouse wrote:
> On Mon, 2006-12-11 at 20:59 +0000, Linux Kernel Mailing List wrote:
> > 
> >     Make sure we populate the initroot filesystem late enough
>
> This seems to be what's triggering the apparent memory corruption we've
> been seeing recently -- in the case of the Fedora kernel it manifests
> itself as a BUG() in cache_alloc_refill() when the pmac ide driver
> initialises.
> 
> Another report was at http://lkml.org/lkml/2006/12/17/4
> 
> We've been seeing it on a Mac Mini too, and I managed to reproduce it on
> my shinybook this evening by booting with 'mem=512M'.

Just for reference (as its not in the thread linked above), this issue
disappeared for me after some config changes (I somehow changed my
selection when I backtracked and then moved forward w/ git bisect).

I've not been able to reproduce it since, but I know others (BCC'ed on
this note) have seen it and might prod them to come forth with details
(and broken .config files)

thanks
-john


