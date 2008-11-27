Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYK0LWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYK0LWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYK0LV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:21:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45697 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYK0LVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:21:55 -0500
Date: Thu, 27 Nov 2008 11:21:24 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Paul Mundt <lethal@linux-sh.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RESEND:PATCH] [ARM] clearpage: provide our own clear_user_highpage()
Message-ID: <20081127112124.GA9233@flint.arm.linux.org.uk>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-arch@vger.kernel.org,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org
References: <20081126171321.GA4719@dyn-67.arm.linux.org.uk> <1227719999.3387.0.camel@localhost.localdomain> <20081127102920.660303a5.sfr@canb.auug.org.au> <20081127010755.GA30854@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127010755.GA30854@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 10:07:55AM +0900, Paul Mundt wrote:
> On Thu, Nov 27, 2008 at 10:29:20AM +1100, Stephen Rothwell wrote:
> > Hi Russell,
> > 
> > On Wed, 26 Nov 2008 11:19:59 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > >
> > > We'd like to pull this trick on parisc as well (another VIPT
> > > architecture), so you can add my ack.
> > 
> > If this is going to be used by more than one architecture during the next
> > merge window, then maybe the change to include/linux/highmem.h could be
> > extracted to its own patch and sent to Linus for inclusion in 2.6.28.
> > This way we avoid some conflicts and the architectures can do their
> > updates independently.
> 
> I plan to use it on VIPT SH also, so getting the higmem.h change in by
> itself sooner rather than later would certainly be welcome.

I'll queue the change to linux/highmem.h for when Linus gets back then.
Can I assume that Hugh and James are happy for their ack to apply to
both parts of the split patch?  And do I have your ack as well?

Thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
