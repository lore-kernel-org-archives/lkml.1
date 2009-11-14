Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZKNKEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZKNKEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 05:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZKNKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 05:04:19 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:37172 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZKNKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 05:04:18 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alexander Holler <holler@ahsoftware.de>
Subject: Re: Problems with p55-express and sleeping usb-hds
Date: Sat, 14 Nov 2009 11:06:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4AFDDDF6.4050907@ahsoftware.de> <4AFDED47.5070606@ahsoftware.de> <4AFE1B0D.3060404@ahsoftware.de>
In-Reply-To: <4AFE1B0D.3060404@ahsoftware.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911141106.51948.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 14. November 2009 03:50:53 schrieb Alexander Holler:
> In the excerpt of the log I've posted before, I've cut out the 
> disconnect of the other drive, which has happend almost at the same time 
> (and with the same consequences) as the one shown. In fact I've cut out 
> one line from the log (sorry for that):
> ---------
> Nov 13 19:08:05 krabat ntpd[3381]: kernel time sync status change 2001
> Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed 
> USB device using ehci_hcd and address 3

Reset.

> Nov 13 19:47:35 krabat kernel: [ 2656.233278] usb 9-1: reset high speed 
> USB device using ehci_hcd and address 4
> Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware 
> changed

Descriptors changed

> Nov 13 19:47:39 krabat kernel: [ 2661.120489] usb 9-7: USB disconnect, 
> address 3

Forced unbind

> ---------
> Afterwards the messages for the second drive where the same as for the 
> one I've posted.
> 
> This is reproducible, at least through starting the rsync. I will turn 
> on some debugging knobs and will see if I can see some more hints in the 
> resulting logs.

You can recompile with CONFIG_USB_DEBUG and CONFIG_USB_STORAGE_DEBUG.

	Regards
		Oliver
