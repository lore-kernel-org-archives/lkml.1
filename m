Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbXK2RK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbXK2RK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbXK2RKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:10:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58645 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760987AbXK2RKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:10:04 -0500
Date: Thu, 29 Nov 2007 09:08:05 -0800
From: Greg KH <greg@kroah.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
Message-ID: <20071129170805.GC10024@kroah.com>
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129073303.1913505tnv2m8v0g@webmail.tugraz.at> <200711290844.39428.oliver@neukum.org> <20071129000149.7569eab1.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129000149.7569eab1.zaitcev@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 12:01:49AM -0800, Pete Zaitcev wrote:
> On Thu, 29 Nov 2007 08:44:38 +0100, Oliver Neukum <oliver@neukum.org> wrote:
> 
> > 3. Make sure usbcore doesn't probe the devices in the wrong mode with the 
> > option driver
> 
> This fixes duplication. And to take it further, why don't we turn this
> idea around and let usb-storage fail to attach with some "ignore" quirk?
> I suspect that someone put the initializer into usb-storage in order
> to let the generic usb serial to work, but this simply was a bad idea.

Yes, I think that is what happened :(

I'll gladly take patches to fix this all up, I have a number of bug
reports for the suse releases with this same problem you are seeing.

thanks,

greg k-h
