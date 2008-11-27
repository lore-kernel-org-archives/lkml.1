Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYK0BLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYK0BLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYK0BJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:09:24 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:62841 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756181AbYK0BJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:09:23 -0500
Date: Thu, 27 Nov 2008 10:07:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RESEND:PATCH] [ARM] clearpage: provide our own clear_user_highpage()
Message-ID: <20081127010755.GA30854@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-arch@vger.kernel.org,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org
References: <20081126171321.GA4719@dyn-67.arm.linux.org.uk> <1227719999.3387.0.camel@localhost.localdomain> <20081127102920.660303a5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127102920.660303a5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 10:29:20AM +1100, Stephen Rothwell wrote:
> Hi Russell,
> 
> On Wed, 26 Nov 2008 11:19:59 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> > We'd like to pull this trick on parisc as well (another VIPT
> > architecture), so you can add my ack.
> 
> If this is going to be used by more than one architecture during the next
> merge window, then maybe the change to include/linux/highmem.h could be
> extracted to its own patch and sent to Linus for inclusion in 2.6.28.
> This way we avoid some conflicts and the architectures can do their
> updates independently.

I plan to use it on VIPT SH also, so getting the higmem.h change in by
itself sooner rather than later would certainly be welcome.
