Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYIKU6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYIKU6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYIKU6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:58:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYIKU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:58:36 -0400
Date: Thu, 11 Sep 2008 13:57:38 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911205738.GB11708@kroah.com>
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com> <1221151165.6309.55.camel@californication> <20080911201541.GA18518@kroah.com> <1221165518.4077.17.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221165518.4077.17.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 01:38:38PM -0700, David Woodhouse wrote:
> On Thu, 2008-09-11 at 13:15 -0700, Greg KH wrote:
> > This is the firmware that is in the kernel source tree, that has been
> > moved to use request_firmware, and was originally tied tightly to the
> > kernel drivers themselves.
> 
> Not really. Most of it hasn't changed for years; it isn't _really_ tied
> that closely to the kernel. 

Some are and some aren't (I have two in my -staging tree that are
changing as the driver changes, so it does happen.)

> You can just ignore what the kernel ships with, and install the firmware
> from the linux-firmware.git repository instead.

So you are now forcing distros to ship the linux-firmware.git repo
instead?  That's not nice and is a totally new dependancy for them to
handle.

What about the very basic fact that kernel versions will stomp on files
from other kernel versions if you install multiple kernels on the same
machine?  That's just bad and ripe for problems in any package
management system.

thanks,

greg k-h
