Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYJWUh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYJWUh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYJWUhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:37:14 -0400
Received: from kroah.org ([198.145.64.141]:56659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752699AbYJWUhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:37:13 -0400
Date: Thu, 23 Oct 2008 13:33:33 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 0/2] x86: check correctness of IRQ0 override
	on systems with ATI/AMD SB450/SB600 chipsets
Message-ID: <20081023203333.GB10715@kroah.com>
References: <20081015104118.GA4706@alberich.amd.com> <20081015191720.GA7966@kroah.com> <20081016120615.GE29183@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016120615.GE29183@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 02:06:15PM +0200, Andreas Herrmann wrote:
> On Wed, Oct 15, 2008 at 12:17:20PM -0700, Greg KH wrote:
> > On Wed, Oct 15, 2008 at 12:41:18PM +0200, Andreas Herrmann wrote:
> > > Hi,
> > > 
> > > following patches should go into 2.6.27-stable tree.
> > > 
> > > They fix issues with HP Laptops that provide a wrong override for IRQ0
> > > and which change the thermal trip point as soon as Linux unmasks
> > > IOAPIC INT2.
> > 
> > Are these patches in the upstream Linus kernel already?
> > 
> > If so, can you please give us the git commit ids?
> 
> The one for SB450 is upstream. It's commit
> 33fb0e4eb53f16af312f9698f974e2e64af39c12
> 
> The second one was posted yesterday and it is not yet commited.
> 
> BTW, I just posted another patch to remove superfluos DMI-quirks
> that are related to HP Laptops with SB450/SB600.
> IMHO this patch should go into stable as well. But first I'd like
> to get a response from Ingo here.

That patch is now in Linus's tree, but it doesn't apply.  Can you
backport it to 2.6.27.3 and send it to stable@kernel.org if you still
want this change to be in the 2.6.27 tree?

thanks,

greg k-h
