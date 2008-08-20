Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYHTU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYHTU3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYHTU33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:29:29 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:52197 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbYHTU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:29:28 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.17-rc3: hci-usb related warnings and error on resume
Date: Wed, 20 Aug 2008 22:28:59 +0200
User-Agent: KMail/1.9.9
References: <200808202055.46558.elendil@planet.nl> <200808202141.01169.rjw@sisk.pl>
In-Reply-To: <200808202141.01169.rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       marcel@holtmann.org, maxk@qualcomm.com, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808202229.01199.elendil@planet.nl>
X-OriginalArrivalTime: 20 Aug 2008 20:29:26.0576 (UTC) FILETIME=[709AFB00:01C90303]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2008, Rafael wrote:
> On Wednesday, 20 of August 2008, Frans Pop wrote:
> > I recently got a new laptop (HP 2510p) and have been playing with
> > suspend/resume. Initially the dmesg after resume was fairly clean,
> > but that was with the bluetooth device disabled (I initially disabled
> > it in Windows).
> >
> > After enabling it I get repeated warnings on resume starting with:
> > <snip>
> > usb 1-1: reset full speed USB device using uhci_hcd and address 3
> > hci_usb 1-1:1.0: no reset_resume for driver hci_usb?
> > hci_usb 1-1:1.1: no reset_resume for driver hci_usb?
> > usb_endpoint usbdev1.3_ep83: parent 1-1:1.1 is sleeping, will not add
> > ------------[ cut here ]------------
> > WARNING: at drivers/base/power/main.c:82 device_pm_add+0x77/0xd3()
> > </snip>
>
> Yeah.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11263#c11
>
> The patch is in the Greg's tree, AFAICS.

Thanks! I'll keep an eye on that and check if the IRQ problem is solved 
too after that patch gets in. If not, I'll try to narrow that one down a 
bit further.
