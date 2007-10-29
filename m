Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbXJ2CiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbXJ2CiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXJ2CiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:38:14 -0400
Received: from mxsf00.insightbb.com ([74.128.0.70]:17417 "EHLO
	mxsf00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXJ2CiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:38:13 -0400
X-IronPort-AV: E=Sophos;i="4.21,339,1188792000"; 
   d="scan'208";a="91391434"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAPnjJEdKjlCP/2dsb2JhbACBWo5u
X-IronPort-AV: E=Sophos;i="4.21,339,1188792000"; 
   d="scan'208";a="89697150"
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: 2.6 patch] remove the USB_STORAGE_ONETOUCH driver
Date: Sun, 28 Oct 2007 22:38:10 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Kosina <jikos@jikos.cz>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Adrian Bunk <bunk@kernel.org>, Nick Sillik <n.sillik@temple.edu>,
       David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <20071028155212.GC7227@stusta.de> <64bb37e0710281048x589ab063o8a32294e30488979@mail.gmail.com> <Pine.LNX.4.64.0710282134020.18815@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710282134020.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710282238.11692.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 October 2007 16:39, Jiri Kosina wrote:
> On Sun, 28 Oct 2007, Torsten Kaiser wrote:
> 
> > But it looks like that uses another driver:
> > hiddev0hidraw1: USB HID v1.10 Device [Western Digital External HDD] on
> > usb-0000:00:02.1-5.2
> > Otherwise I would be willing to try to test this, if someone would tell 
> > me how to check that the second commit did fix the suspend problem.
> 
> If you need to unbind usbhid driver from the device and bind another one, 
> you can use the 'unbind' and 'bind' files in sysfs.
> 
> As soon as the driver you are willing to test is bound to the device, you 
> can go ahead with testing any functionality you wish (probably 
> suspend/resume cycle is needed here?).
> 
> If the device is claimed by usbhid driver (because its descriptor probably 
> states that it's HID-compliant device) and should be claimed by another 
> driver, it's necessary to add it to usbhid blacklist -- just let me know.
> 

Maybe onetouch driver is not needed after all. I wonder what key/button does
HID deriver reports when it binds to it... Torsten, could you please post
your /proc/bus/input/devices?

-- 
Dmitry
