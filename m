Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZDFPre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZDFPre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZDFPrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:47:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:45601 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZDFPrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:47:23 -0400
Date: Mon, 6 Apr 2009 08:26:56 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Christopher Harrer <charrer@alacritech.com>
Subject: Re: Staging: sxg: Add support to download the firmware using
	request_firmware()
Message-ID: <20090406152656.GA25839@suse.de>
References: <200904051919.n35JJUUq031448@hera.kernel.org> <1238978493.11870.2.camel@macbook.infradead.org> <20090406010754.GA32630@suse.de> <1238980795.11870.12.camel@macbook.infradead.org> <20090406023349.GA1314@suse.de> <20090406101026.04040c13@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406101026.04040c13@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 10:10:26AM +0100, Alan Cox wrote:
> > Firmware isn't "crap", it's needed by devices, and I don't see the
> > problem of distributing it within the kernel tree, especially when the
> > license of the firmware is just fine, like these files are.
> 
> For one firmware doesn't tie to the kernel release cycle so any
> serious distribution has to split the two packages apart even if the
> kernel community didn't.

So you are calling distros that don't do this "non-serious" now?  :)

What is the release cycle for this firmware tree?  And where is it
released at?

> For a second it keeps a lot of irrelevant, unreviewable enormous hex file
> changesets *off* the kernel lists and out of the git tree tracking.

git can handle this kind of thing trivially, that should not be an
issue.  And I have not posted firmware updates to the kernel lists
either, they probably just filter them out due to the size anyway.

So for now, as the majority of the distros don't have a separate
firmware package for the kernel, and there seems to not be any
"kernel-wide policy" yet in place, I'll stick to the in-tree location
for new drivers that need such a thing, as long as their firmware is
allowed to be proper redistributed.

thanks,

greg k-h

> 
> 
> Alan
