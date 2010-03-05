Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab0CEMTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:19:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49989 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051Ab0CEMTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:19:18 -0500
Date: Fri, 5 Mar 2010 12:21:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305122129.0c99adf3@lxorguk.ukuu.org.uk>
In-Reply-To: <4B900AB2.1020603@garzik.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	<alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	<alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	<20100304185002.GA23532@srcf.ucam.org>
	<alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	<20100304190450.GA23807@srcf.ucam.org>
	<4B900AB2.1020603@garzik.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Mar 2010 14:32:02 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> On 03/04/2010 02:04 PM, Matthew Garrett wrote:
> > "Please note that these drivers are under heavy development, may or may
> > not work, and may contain userspace interfaces that most likely will be
> > changed in the near future."
> 
> Shipping it as the default Fedora driver for NVIDIA hardware makes that 
> text largely irrelevant.

Why ? Fedora isn't special, Fedora is just a distribution that uses the
Linux kernel. If Fedora turns on staging drivers then Fedora has to
accept that stuff breaks and manage that expectation with its users.
Staging is not and has not been API stable. If staging is going to be API
stable then it it useless and may as well be deleted.

In this case Linus is just a random Fedora user having a distro problem.
I don't even see what it has to do with linux-kernel. The libdrm problem
and difficulty using Fedora libdrm with current upstream kernel is a
Fedora problem not a kernel problem.

The kernel staging tree is unstable for API. Whether thats the Nouveau
guys breaking Fedora, submissions to network drivers breaking/removing
bogus APIs in stuff being cleaned up - whatever then thats how the cookie
crumbles. DRM has just made it all horribly more visible because the
libdrm/kernel stuff has such a complex and closely tied interface.

Serious discussion point perhaps should be: is the libdrm so close to the
kernel it ought to be in the same git tree ? Alternatively does it need
to be easier to have multiple Nouveau libdrms autoselected according to
the kernel side versioning. ELF library versioning is not rocket science
and both the old and new libraries exist and can be installed so all the
bits are present except for the wrapper to load the right sublibrary yes ?

Alan
