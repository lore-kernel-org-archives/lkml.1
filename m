Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZDFCir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZDFCir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 22:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZDFCii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 22:38:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZDFCih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 22:38:37 -0400
Date: Sun, 5 Apr 2009 19:33:49 -0700
From: Greg KH <gregkh@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Christopher Harrer <charrer@alacritech.com>
Subject: Re: Staging: sxg: Add support to download the firmware using
	request_firmware()
Message-ID: <20090406023349.GA1314@suse.de>
References: <200904051919.n35JJUUq031448@hera.kernel.org> <1238978493.11870.2.camel@macbook.infradead.org> <20090406010754.GA32630@suse.de> <1238980795.11870.12.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238980795.11870.12.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 06:19:55PM -0700, David Woodhouse wrote:
> On Sun, 2009-04-05 at 18:07 -0700, Greg KH wrote:
> > Who do we email to add this to?
> 
> Clone git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git,
> add your firmware (and update the WHENCE file accordingly), and send me
> a pull request. Preferably with a Signed-off-by: from within the company
> that owns the firmware in question.

Care to document this somewhere in the kernel tree so we know about it?

> > And finally, what's wrong with adding new firmware images into the
> > firmware/ directory?  What is the issue here?
> 
> We're working on _removing_ this crap from the kernel source tree -- not
> adding new instances of it.

Firmware isn't "crap", it's needed by devices, and I don't see the
problem of distributing it within the kernel tree, especially when the
license of the firmware is just fine, like these files are.

> We have a separate repository in which we're collecting
> redistributable firmware images, and the distributions are moving
> towards shipping that instead of just the legacy stuff from the kernel
> tree. Add any new firmware to that repository instead, as described
> above.

Are there releases of the firmware tree published and announced
anywhere so the distros know to do this?

thanks,

greg k-h
