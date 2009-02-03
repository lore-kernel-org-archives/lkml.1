Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZBCPwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZBCPwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZBCPv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:51:58 -0500
Received: from kroah.org ([198.145.64.141]:55145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755389AbZBCPv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:51:58 -0500
Date: Tue, 3 Feb 2009 07:47:45 -0800
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] UWB and WUSB fixes
Message-ID: <20090203154745.GA27533@kroah.com>
References: <49873632.6040108@csr.com> <20090203051244.GA1826@kroah.com> <49885139.3070106@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49885139.3070106@csr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 02:14:17PM +0000, David Vrabel wrote:
> Greg KH wrote:
> > On Mon, Feb 02, 2009 at 06:06:42PM +0000, David Vrabel wrote:
> >>  drivers/usb/host/whci/asl.c       |    9 +++++++--
> >>  drivers/usb/host/whci/hw.c        |   15 +++++++++++++++
> >>  drivers/usb/host/whci/pzl.c       |    9 +++++++--
> >>  drivers/usb/host/whci/whcd.h      |    1 +
> >>  drivers/usb/wusbcore/devconnect.c |    1 +
> >>  drivers/usb/wusbcore/rh.c         |    3 +++
> > 
> > For patches under drivers/usb/ could you please route them through me?
> > It makes things a bit easier to coordinate at times.  Not that there is
> > a problem at all with these patches, but in the future it would be
> > nicer.
> 
> This is more work for me (and you) and I don't see the benefit.  Could
> you expand on what situations you see this as helping?

I carry changes to drivers/usb/host all the time that can affect whci
due to changes in the USB hcd interface.  Also, people end up sending me
patches for these files for things like header file cleanups and other
minor stuff.

So that can potentially conflict with stuff you are doing without the
my knowledge.

Also, it would be good to have the linux-usb developers at least review
any changes to these files, myself included, right?

It shouldn't be any more work for you, just send the patches to me and
forget about them, I'll queue them up at the proper time :)

thanks,

greg k-h
