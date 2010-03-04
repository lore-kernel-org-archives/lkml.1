Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0CDCwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:52:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0CDCw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:52:27 -0500
Date: Wed, 3 Mar 2010 18:50:46 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uartlite: Fix build on sparc.
Message-ID: <20100304025046.GA9692@suse.de>
References: <20100303.025026.243831910.davem@davemloft.net> <fa686aa41003031055o25fd62b6u3c68d6b69d7c6d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa41003031055o25fd62b6u3c68d6b69d7c6d1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:55:49AM -0700, Grant Likely wrote:
> On Wed, Mar 3, 2010 at 3:50 AM, David Miller <davem@davemloft.net> wrote:
> >
> > We can get this driver enabled via MFD_TIMBERDALE which only
> > requires GPIO to be on.
> >
> > But the of_address_to_resource() function is only present on
> > powerpc and microblaze, so we have to conditionalize the
> > CONFIG_OF probing bits on that.
> >
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Linus or Greg, can you please pick this bug fix up?

I can if someone sends it to me in a form I can apply it :)

thanks,

greg k-h
