Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZISWr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZISWr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZISWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:47:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZISWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:47:55 -0400
Date: Sat, 19 Sep 2009 15:44:30 -0700
From: Greg KH <greg@kroah.com>
To: Alok Kataria <akataria@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090919224430.GB9567@kroah.com>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253233028.19731.63.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 05:17:08PM -0700, Alok Kataria wrote:
> Given this new development, I wanted to discuss how should we go about
> retiring the VMI code from mainline Linux, i.e. the vmi_32.c and
> vmiclock_32.c bits.
> 
> One of the options that I am contemplating is to drop the code from the
> tip tree in this release cycle, and given that this should be a low risk
> change we can remove it from Linus's tree later in the merge cycle.

That sounds good to me, how intrusive are the patches to do this?  Is it
going to be tricky to get everything merged properly in -tip for it?

thanks,

greg k-h
