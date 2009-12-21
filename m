Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZLURZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZLURZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZLURZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:25:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbZLURZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:25:38 -0500
Date: Mon, 21 Dec 2009 09:14:45 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] Driver core: export platform_device_register_data as a
 GPL symbol
Message-ID: <20091221171445.GA27870@suse.de>
References: <1261413668-30145-1-git-send-email-vapier@gentoo.org>
 <20091221164619.GA27521@suse.de>
 <8bd0f97a0912210905s1a9512ffp45bf77555b3685df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0912210905s1a9512ffp45bf77555b3685df@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 12:05:40PM -0500, Mike Frysinger wrote:
> On Mon, Dec 21, 2009 at 11:46, Greg KH wrote:
> > On Mon, Dec 21, 2009 at 11:41:08AM -0500, Mike Frysinger wrote:
> >> This allows MFD's to register/bind drivers for their sub devices while
> >> still being compiled as a module.
> >
> > Is this a problem that we need to get resolved in .33, or older kernels,
> > or just for .34?
> 
> the functionality is in place now, so it could be used in .33.  but it
> isnt that big of a deal to simply say the mfd core cant be built as a
> module right now.
> 
> so, it'd be nice for .33, but if it's too much hassle, .34 is OK.

Ok, I'll queue it up for .33, as it keeps an in-kernel driver from
working properly now.

thanks,

greg k-h
