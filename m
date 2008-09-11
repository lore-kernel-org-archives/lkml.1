Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYIKUVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYIKUVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYIKUUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:20:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYIKUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:20:40 -0400
Date: Thu, 11 Sep 2008 13:18:42 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911201842.GB18518@kroah.com>
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com> <1221151165.6309.55.camel@californication> <1221151538.8593.36.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221151538.8593.36.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 09:45:38AM -0700, David Woodhouse wrote:
> On Thu, 2008-09-11 at 18:39 +0200, Marcel Holtmann wrote:
> > What is wrong with moving the firmware into its own package with its
> > own version number?
> 
> Nothing. You can do this today, building from the linux-firmware
> repository. That repository is starting to contain extra firmware that
> vendors are now willing to let us distribute -- where they _weren't_
> willing to let us distribute it as part of the kernel.

That's great and wonderful and has absolutely nothing to do with the
real problem we have right now in 2.6.27-rc.

Jeff's patch is one proposed solution for the problem, what's the
objection to it?  Reliance on a udev change to catch this as well?  It
looks like SuSE and Ubuntu already handle this, and I'm sure Fedora can
as well, right?

If the udev script requirement is a problem, then how does anyone else
suggest to solve the problem that we currently have with the existing
code?

thanks,

greg k-h
