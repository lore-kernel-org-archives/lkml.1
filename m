Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYGOQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYGOQcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYGOQcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:32:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbYGOQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:32:04 -0400
Date: Tue, 15 Jul 2008 08:53:13 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dropping WUSB/UWB from my patch queue
Message-ID: <20080715155313.GA3075@kroah.com>
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4871E9F0.60608@csr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 11:03:28AM +0100, David Vrabel wrote:
> Greg KH wrote:
> > Hi David,

Sorry for the delay, was on vacation all last week without email access,
and am on a business trip this week with very limited email access :(

> > In looking further at the WUSB/UWB code, it doesn't look like it is
> > going to make it for the 2.6.27 kernel tree due to the reliance on some
> > contriversial core USB changes as well as a total lack of documentation
> > for the sysfs apis.
> 
> I assume you are referring to the usb_dev_reset_delayed() change here.
> This is only required by the wire adapter code and should not prevent
> the majority of the UWB and WUSB stack from being merged.

Ok, thanks for letting me know, I did not realize this.

> You should postpone:
> 
> usb-add-usb_dev_reset_delayed.patch
> wusb-add-the-wire-adapter-core.patch
> wusb-add-hwa-hc-wireless-host-controller-driver.patch
> wusb-wa-abort-rpipe-request-type-fix.patch

Will the code still work properly for users with these patches removed?
If so, I'll reconsider sending this for 2.6.27.

> I will correct the lack of sysfs API documentation this week.  Please
> advise on where the documentation should go and its style and format.
> Be aware that some of the API is experimental and subject to change. I
> will ensure the documentation is clear on this and that the Kconfig
> entries depend on EXPERIMENTAL.
> 
> Would this be sufficient to reinstate the majority of the UWB and WUSB
> stacks for 2.6.27?

Yes.  I'll take what you sent me, and try to reorder things to make it
so that we can get the majority of the code into .27, I don't want this
to live outside the tree for any longer either, that's why I started
working on getting this mess cleaned up in the first place :)

> > Because of this, I've dropped all of the patches from my USB queue, so
> > they will no longer show up in the -next releases anymore.
> 
> In future, it would be appreciated if any issues with UWB patches are
> discussed rather than summarily dropping them.

Hey, they were not "dropped" in the format that they suddenly
disappeared, they are still around and useful :)

thanks,

greg k-h
