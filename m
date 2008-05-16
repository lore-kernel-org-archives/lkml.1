Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYEPH0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYEPH0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYEPH0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:26:38 -0400
Received: from eazy.amigager.de ([213.239.192.238]:49410 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYEPH0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:26:37 -0400
Date: Fri, 16 May 2008 09:26:34 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080516072634.GA4867@dose.home.local>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg KH <greg@kroah.com>, linux-input@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local> <20080515094212.ZZRA012@mailhub.coreip.homeip.net> <20080515174939.GA10881@dose.home.local> <20080515142845.ZZRA012@mailhub.coreip.homeip.net> <20080515205950.GA11794@dose.home.local> <Pine.LNX.4.64.0805160917350.11363@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805160917350.11363@jikos.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 09:19:39 +0200, Jiri Kosina wrote:
> On Thu, 15 May 2008, Tino Keitel wrote:
> 
> > Does setting the quirks to 0 lead to the creation of a HID device 
> > immediately? 
> 
> The easiest way is either to handle this in the early stage, i.e. specify 
> 'quirks' module parameter during the module insertion.
> 
> Other possibility is to detach the driver from the device using 'unbind' 
> functionality of sysfs. libusb has a call for this too.

Thanks for the hint.

So I guess that the LIRC driver should be extended to watch out for a
USB device with the prober vendor/device ID and unbind it before usage,
right?

This wouldn't help users who use the current LIRC with a kernel that
has the HID ignore quirk enabled by default, though (i.e., it would be
a regression).

Regards,
Tino
