Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXBDDTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXBDDTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 22:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXBDDTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 22:19:42 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:64490 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751896AbXBDDTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 22:19:41 -0500
Date: Sat, 3 Feb 2007 22:19:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb-users@lists.sourceforge.net>
Subject: Re: [Linux-usb-users] 2.6.20-rc7 USB issue(?) [disabled by hub(EMI?)]
In-Reply-To: <Pine.LNX.4.64.0702031903550.29127@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0702032215250.17500-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Justin Piszcz wrote:

> Not sure if this is normal or not, was not doing anything out of the 
> ordinary and after secs/3600..  ~ 42hrs this occured?
> 
> $ uptime
>   19:06:17 up 2 days, 29 min, 10 users,  load average: 0.13, 0.07, 0.06
> 
> $ uname -ra
> Linux p34 2.6.20-rc7 #2 SMP Wed Jan 31 20:03:09 EST 2007 i686 GNU/Linux
> 
> One thing I did recently was upgrade to a newer Intel Motherboard BIOS but 
> this is also the first time I have run 2.6.20-rc7 for this long as well.
> 
> Any clues?
> 
> [151698.814092] hub 6-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
> [151698.814102] usb 6-2: USB disconnect, address 2
> [151698.917209] usb 6-2: new low speed USB device using uhci_hcd and 
> address 3
> [151699.078032] usb 6-2: configuration #1 chosen from 1 choice
> [151699.525889] hiddev96: USB HID v1.00 Device [        UPS] on 
> usb-0000:00:1d.1-2
> 
> Mobo: Intel DG965WHMKR
> Bios: 1618 (latest)
> 
> Could this have been from an apt-get update/upgrade?  Perhaps it upgraded 
> something that would probe/look at the USB bus?

It could be.  I just found a bug in the USB core for 2.6.20-rc which might 
be responsible.

On the other hand, maybe it was just some random occurrence.  Noise on the
USB data line or something like that.  Considering your record of
untroubled uptime, this seems likely.  Of course, if it keeps happening
then we should look for a systematic cause.

Alan Stern

