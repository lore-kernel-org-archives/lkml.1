Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0CDEe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:34:58 -0500
Received: from kroah.org ([198.145.64.141]:38760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab0CDEez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:34:55 -0500
Date: Wed, 3 Mar 2010 20:34:55 -0800
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] uartlite: Fix build on sparc.
Message-ID: <20100304043455.GA11870@kroah.com>
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

Ok, I found it in the archives, I'll take this now.

thanks,

greg k-h
