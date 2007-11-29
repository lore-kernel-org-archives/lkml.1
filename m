Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbXK2Eah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbXK2Eah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 23:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXK2Ea1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 23:30:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706AbXK2Ea0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 23:30:26 -0500
Date: Wed, 28 Nov 2007 20:33:07 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] base/class.c: prevent ooops due to insert/remove race
Message-ID: <20071129043307.GA4766@suse.de>
References: <474E3964.7040200@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474E3964.7040200@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 11:00:36PM -0500, Mark Lord wrote:
> While doing insert/remove (quickly) tests on USB, I managed to trigger
> an Oops on 2.6.23.1 on the call to strlen() in make_class_name().
>
> This patch prevents this oops.
>
> There is still the larger problem of the overall race
> that caused this in the first place, but much of the rest
> of the code in class.c appears to also do NULL checks to
> avoid Oops'ing, so this continues the tradition.
>
> Signed-off-by:  Mark Lord <mlord@pobox.com>

As this is a bandage over the real problem, I'd prefer to not apply this
one right now until we find the root cause.

thanks,

greg k-h
