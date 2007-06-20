Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXFTLH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXFTLH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXFTLHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:07:19 -0400
Received: from smtp-01b.mandic.com.br ([200.225.81.136]:54235 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752588AbXFTLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:07:17 -0400
Message-ID: <46790A61.5070107@mandic.com.br>
Date: Wed, 20 Jun 2007 08:07:13 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       Jiri Kosina <jikos@jikos.cz>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] Error -71 on device descriptor read/all
References: <Pine.LNX.4.44L0.0706191456030.2552-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706191456030.2552-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Mandic-no-Celular-to: renatoyamane@mandic.com.br
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Does the mouse work correctly, even with ehci-hcd loaded?

Yes.
And sorry, but I don't have any other USB2.0 device to test.
I try with my cel phone (Motorola V3i) in this night (GMT-3).

> If it does then don't worry about the -71 error.  It appears to be 
> transient and it's not necessarily fatal.

In my dmesg today, I see this:
usb 1-1: can't set config #1, error -71

When I remove and input (again) my Mouse, I see this in /var/log/messages:

kernel: usb 1-1: USB disconnect, address 3
kernel: usb 1-1: new low speed USB device using uhci_hcd and address 4
kernel: usb 1-1: configuration #1 chosen from 1 choice
kernel: input: Microsoft Microsoft 3-Button Mouse with IntelliEye? as 
/class/input/input8
kernel: input: USB HID v1.00 Mouse [Microsoft Microsoft 3-Button Mouse 
with IntelliEye?] on usb-0000:00:1d.0-1

Regards,
Renato S. Yamane
