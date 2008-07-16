Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYGPGGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYGPGGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGPGGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:06:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYGPGGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:06:41 -0400
Date: Tue, 15 Jul 2008 22:49:11 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       linux-usb <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Dropping WUSB/UWB from my patch queue
Message-ID: <20080716054911.GA9806@kroah.com>
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com> <20080715155313.GA3075@kroah.com> <487CE2E7.90505@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487CE2E7.90505@csr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 06:48:23PM +0100, David Vrabel wrote:
> Greg KH wrote:
> > On Mon, Jul 07, 2008 at 11:03:28AM +0100, David Vrabel wrote:
> >> Greg KH wrote:
> >>> Hi David,
> > 
> >>> In looking further at the WUSB/UWB code, it doesn't look like it is
> >>> going to make it for the 2.6.27 kernel tree due to the reliance on some
> >>> contriversial core USB changes as well as a total lack of documentation
> >>> for the sysfs apis.
> >> I assume you are referring to the usb_dev_reset_delayed() change here.
> >> This is only required by the wire adapter code and should not prevent
> >> the majority of the UWB and WUSB stack from being merged.
> > 
> > Ok, thanks for letting me know, I did not realize this.
> > 
> >> You should postpone:
> >>
> >> usb-add-usb_dev_reset_delayed.patch
> >> wusb-add-the-wire-adapter-core.patch
> >> wusb-add-hwa-hc-wireless-host-controller-driver.patch
> >> wusb-wa-abort-rpipe-request-type-fix.patch
> 
> I took another look at where usb_dev_reset_delayed() is used and there
> are more places.  You will also need to postpone:
> 
> uwb/uwb-add-hwa-rc-radio-controller-driver.patch
> uwb/uwb-i1480-driver.patch
> uwb/uwb-i1480-wlp-driver.patch
> uwb/uwb-disable-command-event-filtering-for-DUB-1210.patch
> uwb/uwb-add-intel-i1480-hwa-to-the-uwb-rc-quirk-table.patch
> 
> And since there are now no drivers for WLP hardware you may also postpone:
> 
> uwb/uwb-add-wimedia-llc-protocol-core.patch
> uwb/uwb-wlp-messages.patch
> uwb/uwb-wlp-wss.patch
> uwb/uwb-wlp-build-system.patch
> uwb/wusb-drivers-uwb-wlp-sysfs.c-move-misplaced-debug-statement.patch

Ugh, so, what will end up getting merged?  Anything that people can
actually use?  :)

I'll poke at this on Friday and see what falls out.

thanks,

greg k-h
